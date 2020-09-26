//
//  ViewController.swift
//  turtleAppLayout
//
//  Created by Olivia James on 8/25/20.
//  Copyright © 2020 Sebastien James. All rights reserved.
//

import UIKit
import CoreLocation
import RealmSwift
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage


class ObservationViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    var data = Observation()
    var hatch = Hatching()
    
//    
    
    let realm = try! Realm()
    let db = Firestore.firestore()
    
    let storage = Storage.storage()
    
    let locationManager = CLLocationManager()
    
    let imagePicker = UIImagePickerController()
    
    let defaults = UserDefaults.standard
    //Setting user id if doesn't exist, replace with the log + alert
    var userID: String = ""
    
    
    var image = 0
    var documentsDirectoryPath = ""
    
    @IBOutlet weak var zoneButton: UIButton!
    @IBOutlet weak var propertyButton: UIButton!
    
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var accuracy: UILabel!
    
    @IBOutlet weak var emergeButton: UIButton!
    @IBOutlet weak var existingNestButton: UIButton!
    @IBOutlet weak var turtleButton: UIButton!

    
    @IBOutlet weak var photoImage1: UIImageView!
    @IBOutlet weak var photoImage2: UIImageView!
    @IBOutlet weak var photoImage3: UIImageView!
    @IBOutlet weak var photoImage4: UIImageView!
    @IBOutlet weak var photoImage5: UIImageView!
    
    @IBOutlet weak var commentsTextView: UITextView!
    @IBOutlet weak var hatchingButton: UIButton!
    
    @IBOutlet weak var noProblemsButton: UIButton!
    @IBOutlet weak var lightsButton: UIButton!
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var sewerButton: UIButton!
    @IBOutlet weak var plantsButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    
    @IBOutlet weak var successButton: UIButton!
    @IBOutlet weak var strandedButton: UIButton!
    @IBOutlet weak var deadButton: UIButton!
    
    
    
    //    @IBOutlet weak var commentsTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        if data.hatchingDetails != nil && data.hatchingDetails?.hatchingExists != false {
//                   print("NOT NIL")
//                    print(data.hatchingDetails?.hatchingExists)
//                   hatchingButton.setTitle("Hatching ✓", for: .normal)
//               } else {
//                   hatchingButton.setTitle("Hatching?", for: .normal)
//               }
    }
    
    func didDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Observation"
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        self.commentsTextView.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ObsToHatching" {
//            let vc = segue.destination as! HatchingViewController
//            vc.obs = data
//        }
//    }
    
    
    //MARK:- IBActions: Data Entry
    @IBAction func zoneButtonPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "SELECT A ZONE", message: "", preferredStyle: .alert)
        
        for zone in K.zones {
            let action = UIAlertAction(title: zone, style: .default) { (_) in
                if self.data.zoneLocation != zone {
                    self.data.property = ""
                    self.propertyButton.setTitle("Property/Lot?", for: .normal)
                }
                sender.setTitle("Zone \(zone) ✓", for: .normal)
                self.data.zoneLocation = zone
                
            }
            alert.addAction(action)
        }
        
        alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { (_) in
            sender.setTitle("Zone?", for: .normal)
            self.data.zoneLocation = ""
            self.data.property = ""
            self.propertyButton.setTitle("Property/Lot?", for: .normal)
        }))
        
        present(alert, animated: true)
        alert.view.tintColor = UIColor.black
            
    }
    
    @IBAction func propertyButtonPressed(_ sender: UIButton) {
        var propertyList: Array<(String, String)>?
        switch data.zoneLocation {
        case "A":
            propertyList = K.propertiesInA
        case "B":
            propertyList = K.propertiesInB
        case "C":
            propertyList = K.propertiesInC
        case "D":
            propertyList = K.propertiesInD
        case "E":
            propertyList = K.propertiesInE
        case "F":
            propertyList = K.propertiesInF
        default:
            let alert = UIAlertController(title: "SELECT ZONE FIRST", message: "", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
        }
        
        if let propertyList = propertyList {
            let alert = UIAlertController(title: "SELECT A PROPERTY FROM ZONE \(data.zoneLocation)", message: "", preferredStyle: .alert)
                 
            for property in propertyList {
                alert.addAction(UIAlertAction(title: "\(property.0) : \(property.1)", style: .default, handler: { (_) in
                    self.data.property = property.0
                    sender.setTitle("\(property.0) : \(property.1)", for: .normal)
                }))
            }
            
            alert.addAction(UIAlertAction(title: "CLEAR SELECTION", style: .cancel, handler: { (_) in
                sender.setTitle("Property/Lot?", for: .normal)
                
            }))
            present(alert, animated: true)
            alert.view.tintColor = UIColor.black
            
        }
    }
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        // if lat and lon are both 0, then get location.  If lat and lon != 0, then present alert:
//            (1) get location again, (2) clear existing loc data (reset to 0), (3) cancel/do nothing
        
        //Get location with CoreLocation
        locationManager.requestLocation()
        sender.setTitle("Getting: hold position . . .", for: .normal)
    }
    
    @IBAction func photo1ButtonPressed(_ sender: UIButton) {
        image = 1
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func handleGesture1(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
           case .began:

               UIView.animate(withDuration: 0.05,
                              animations: {
                                self.photoImage1.transform = CGAffineTransform(scaleX: 8.0, y: 8.0)

               },
                              completion: nil)
           case .ended:
               UIView.animate(withDuration: 0.05) {
                   self.photoImage1.transform = CGAffineTransform.identity
               }
           default: break
           }
    }
    
    @IBAction func photo2ButtonPressed(_ sender: UIButton) {
            image = 2
            
            present(imagePicker, animated: true, completion: nil)

    }
    
    @IBAction func handleGesture2(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
           case .began:
               UIView.animate(withDuration: 0.05,
                              animations: {
                                self.photoImage2.transform = CGAffineTransform(scaleX: 8.0, y: 8.0)
               },
                              completion: nil)
           case .ended:
               UIView.animate(withDuration: 0.05) {
                   self.photoImage2.transform = CGAffineTransform.identity
               }
           default: break
           }
    }
    
    @IBAction func photo3ButtonPressed(_ sender: UIButton) {
        image = 3
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func handleGesture3(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
            case .began:
                UIView.animate(withDuration: 0.05,
                               animations: {
                                 self.photoImage3.transform = CGAffineTransform(scaleX: 8.0, y: 8.0)
                },
                               completion: nil)
            case .ended:
                UIView.animate(withDuration: 0.05) {
                    self.photoImage3.transform = CGAffineTransform.identity
                }
            default: break
            }
    }
    
    @IBAction func photo4ButtonPressed(_ sender: UIButton) {
         image = 4
         
         present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func handleGesture4(_ sender: UILongPressGestureRecognizer) {
   
        switch sender.state {
            case .began:
                UIView.animate(withDuration: 0.05,
                               animations: {
                                 self.photoImage4.transform = CGAffineTransform(scaleX: 8.0, y: 8.0)
                },
                               completion: nil)
            case .ended:
                UIView.animate(withDuration: 0.05) {
                    self.photoImage4.transform = CGAffineTransform.identity
                }
            default: break
            }
    }
    
    @IBAction func photo5ButtonPressed(_ sender: UIButton) {
        image = 5
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func handleGesture5(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
            case .began:
                UIView.animate(withDuration: 0.05,
                               animations: {
                                 self.photoImage5.transform = CGAffineTransform(scaleX: 8.0, y: 8.0)
                },
                               completion: nil)
            case .ended:
                UIView.animate(withDuration: 0.05) {
                    self.photoImage5.transform = CGAffineTransform.identity
                }
            default: break
            }
    }
    
    @IBAction func emergeButtonPressed(_ sender: UIButton) {

        if !data.emerge {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "NEW/PROBABLE NEST", style: .default, handler: { (action) in
                sender.setTitle("New Nest ✓", for: .normal)
                self.data.emergeType = "nest"
            }))
            alert.addAction(UIAlertAction(title: "FALSE NEST", style: .default, handler: { (action) in
                sender.setTitle("False Nest ✓", for: .normal)
                self.data.emergeType = "false nest"
            }))
            alert.addAction(UIAlertAction(title: "FALSE CRAWL", style: .default, handler: { (action) in
                self.data.emergeType = "false crawl"
                sender.setTitle("False Crawl ✓", for: .normal)
                
            }))
    
            
            present(alert, animated: true)
            alert.view.tintColor = UIColor.black
            
        } else {
            sender.setTitle("New Nest?", for: .normal)
            data.emergeType = ""
        }
        
        
        data.emerge = !data.emerge
        
    }
    
    @IBAction func existingNestButtonPressed(_ sender: UIButton) {
        
        if !data.existingNestDisturbed {
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            //            action.setValue(UIColor.orange, forKey: "titleTextColor") Sebo:  Don't know where to put this to make it actually do something.
            
            alert.addAction(UIAlertAction(title: "DISTURBED: NATURAL CAUSE", style: .default, handler: { (action) in
                
                self.data.existingNestDisturbedType = "disturbed nature"
                sender.setTitle("Disturb/Nature ✓", for: .normal)
                
            }))
            alert.addAction(UIAlertAction(title: "DISTURBED: HUMAN CAUSE", style: .default, handler: { (action) in
                
                self.data.existingNestDisturbedType = "disturbed human"
                sender.setTitle("Disturb/Human ✓", for: .normal)
                
            }))

            alert.addAction(UIAlertAction(title: "LOST: NATURAL CAUSE", style: .default, handler: { (action) in
                self.data.existingNestDisturbedType = "lost nature"
                sender.setTitle("Lost/Nature ✓", for: .normal)
                
            }))
            
            alert.addAction(UIAlertAction(title: "LOST: HUMAN CAUSE", style: .default, handler: { (action) in
                self.data.existingNestDisturbedType = "lost human"
                sender.setTitle("Lost/Human ✓", for: .normal)
                
            }))
            
            alert.addAction(UIAlertAction(title: "MOVED FROM: NATURAL CAUSE", style: .default, handler: { (action) in
                self.data.existingNestDisturbedType = "moved from/ nature"
                sender.setTitle("Move From/Nat. ✓", for: .normal)
                
            }))
            
            alert.addAction(UIAlertAction(title: "MOVED FROM: HUMAN ACTIVITY", style: .default, handler: { (action) in
                self.data.existingNestDisturbedType = "moved from/ human"
                sender.setTitle("Move From/Human ✓", for: .normal)
                
            }))
            
            alert.addAction(UIAlertAction(title: "MOVED TO", style: .default, handler: { (action) in
                self.data.emergeType = "moved to"
                sender.setTitle("Moved To ✓", for: .normal)
                
            }))
            
            present(alert, animated: true)
            //            YAY!  MAGIC!
            alert.view.tintColor = UIColor.black
            
        } else {
            sender.setTitle("Old Nest?", for: .normal)
            data.existingNestDisturbedType = ""
        }
        data.existingNestDisturbed = !data.existingNestDisturbed
        
    }
    
    @IBAction func turtleButtonPressed(_ sender: UIButton) {
        if !data.turtle {
            
            let alert = UIAlertController(title: "ADULT TURTLE:", message: "", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "DEAD", style: .default, handler: { (action) in
                self.data.turtleType = "dead"
                sender.setTitle("Dead Adult ✓", for: .normal)
            }))
            alert.addAction(UIAlertAction(title: "ALIVE", style: .default, handler: { (action) in
                self.data.turtleType = "live"
                sender.setTitle("Live Adult ✓", for: .normal)
            }))
            
            present(alert, animated: true)
            alert.view.tintColor = UIColor.black
            
        } else {
            sender.setTitle("Adult Turtle?", for: .normal)
            data.turtleType = ""
        }
        data.turtle = !data.turtle
        
    }
    
    @IBAction func hatchingButtonPressed(_ sender: UIButton) {
        data.hatchingBool = !data.hatchingBool
        if data.hatchingBool {
            sender.setTitle("Hatching ✓", for: .normal)
            print("Hatching true")
        } else {
            sender.setTitle("Hatching?", for: .normal)
            print("No hatching")
        }
        
    }

    @IBAction func noProblemsButtonPressed(_ sender: UIButton) {
        data.noProblems = !data.noProblems
        if data.noProblems {
            sender.setTitle("No Problems ✓", for: .normal)
            
//     Consider whether to make selecting "No Problems" clear all the other problems
//            lightsButton.setTitle("Lights", for: .normal)
//            trashButton.setTitle("Trash", for: .normal)
//            sewerButton.setTitle("Sewer", for: .normal)
//            plantsButton.setTitle("Plants", for: .normal)
//            otherButton.setTitle("Other", for: .normal)
            print("No problems")
        } else {
            sender.setTitle("No Problems", for: .normal)
            print("Problems")
        }
    }
    
    @IBAction func lightsButtonPressed(_ sender: UIButton) {
        data.lights = !data.lights
        if data.lights {
            sender.setTitle("Lights ✓", for: .normal)
            print("Light problem")
        } else {
            sender.setTitle("Lights", for: .normal)
            print("No light problem")
        }
    }
    
    @IBAction func trashButtonPressed(_ sender: UIButton) {
        data.trash = !data.trash
         if data.trash {
             sender.setTitle("Trash ✓", for: .normal)
             print("Trash problem")
         } else {
             sender.setTitle("Trash", for: .normal)
             print("No Trash problem")
         }
    }
    
    @IBAction func sewerButtonPressed(_ sender: UIButton) {
        data.sewer = !data.sewer
        if data.sewer {
            sender.setTitle("Sewer ✓", for: .normal)
            print("sewer problem")
        } else {
            sender.setTitle("Sewer", for: .normal)
            print("No sewer problem")
        }
    }
    
    @IBAction func plantsButtonPressed(_ sender: UIButton) {
        data.plants = !data.plants
        if data.plants {
            sender.setTitle("Plants ✓", for: .normal)
            print("plants problem")
        } else {
            sender.setTitle("Plants", for: .normal)
            print("No Plants problem")
        }
    }
    
    @IBAction func otherButtonPressed(_ sender: UIButton) {
        data.other = !data.other
          if data.other {
              sender.setTitle("Other ✓", for: .normal)
              print("Other problem")
          } else {
              sender.setTitle("Other", for: .normal)
              print("No other problem")
          }
    }
    
    @IBAction func successButtonPressed(_ sender: UIButton) {
        var myTextField : UITextField?
        let alert = UIAlertController.init(title: "Estimate the number of babies that went unassisted to ocean", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            // make sure your outside any property should be accessed with self here
            myTextField = textField
            //Important step assign textfield delegate to self
            myTextField?.delegate = self
            myTextField?.placeholder = "0"
            myTextField?.keyboardType = .numberPad
        }
            
             alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { (_) in
                 sender.setTitle("# Success", for: .normal)
             }))
        
             alert.addAction(UIAlertAction(title: "DONE", style: .default, handler: { (action) in
                 guard let num = Int(myTextField!.text!) else { return }
                self.data.numSuccess = num
                 sender.setTitle("\(num) Success", for: .normal)
             }))

             present(alert, animated: true, completion:nil)
            alert.view.tintColor = UIColor.black

            
    }
    
    @IBAction func strandedButtonPressed(_ sender: UIButton) {
         var myTextField : UITextField?
         let alert = UIAlertController.init(title: "Enter number of babies that were stranded and needed rescue", message: nil, preferredStyle: .alert)
         alert.addTextField { (textField) in
             myTextField = textField
             myTextField?.delegate = self
             myTextField?.placeholder = "0"
             myTextField?.keyboardType = .numberPad
         }
         
         alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { (_) in
             sender.setTitle("# Stranded", for: .normal)
         }))
    
         alert.addAction(UIAlertAction(title: "DONE", style: .default, handler: { (action) in
             guard let num = Int(myTextField!.text!) else { return }
            self.data.numStranded = num
             sender.setTitle("\(num) Stranded", for: .normal)
         }))

        present(alert, animated: true, completion:nil)
        alert.view.tintColor = UIColor.black

    }
    
    @IBAction func deadButtonPressed(_ sender: UIButton) {
        var myTextField : UITextField?
        let alert = UIAlertController.init(title: "Enter number of dead babies found", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            myTextField = textField
            myTextField?.delegate = self
            myTextField?.placeholder = "0"
            myTextField?.keyboardType = .numberPad
        }
        
        alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { (_) in
            sender.setTitle("# Dead", for: .normal)
        }))

        alert.addAction(UIAlertAction(title: "DONE", style: .default, handler: { (action) in
            guard let num = Int(myTextField!.text!) else { return }
            self.data.numDead = num
            sender.setTitle("\(num) Dead", for: .normal)
        }))

        present(alert, animated: true, completion:nil)
        alert.view.tintColor = UIColor.black

    }
    
    
    
    
    
    //MARK:- Save Data
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "SAVE THIS OBSERVATION AND CLEAR ALL FIELDS?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (_) in
            
            self.data.comments = self.commentsTextView.text ?? ""
            
            // create id
            var id = "\(self.data.zoneLocation)-" != "" ? "\(self.data.zoneLocation)-": "-"
            
            if self.data.emerge { id.append(self.data.emergeType == "nest" ? "N" : "F") }
            if self.data.existingNestDisturbed { id.append(self.data.existingNestDisturbedType == "disturbed" ? "D" : "R") }
            id.append(self.data.turtle ? "T" : "")

            if self.data.noProblems || self.data.lights || self.data.trash || self.data.sewer || self.data.plants || self.data.other || self.data.numSuccess != 0 || self.data.numStranded != 0 || self.data.numDead != 0 {
                    
                self.data.hatchingBool = true
                
                } else {
                    self.data.hatchingBool = false
                }
            
            
            id.append(self.data.hatchingBool ? "H" : "")
            
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "-yyyyMMdd-HHmmss-"
            
            id.append(dateFormatter.string(from: Date()))
            id.append(self.defaults.string(forKey: "userID") ?? "NOUSER")
            self.data.id = id
            
            
            do {
                try self.realm.write {
                    self.realm.add(self.data)
                }
                
                //Reset all fields if successfully saved
                self.zoneButton.setTitle("Zone?", for: .normal)
                self.propertyButton.setTitle("Property/Lot?", for: .normal)
                self.locationButton.setTitle("Get GPS Location", for: .normal)
                self.emergeButton.setTitle("Emergence?", for: .normal)
                self.existingNestButton.setTitle("Existing Nest?", for: .normal)
                self.turtleButton.setTitle("Adult Turtle?", for: .normal)
                self.hatchingButton.setTitle("Hatching?", for: .normal)
                self.noProblemsButton.setTitle("No Problems", for: .normal)
                self.lightsButton.setTitle("Lights", for: .normal)
                self.trashButton.setTitle("Trash", for: .normal)
                self.sewerButton.setTitle("Sewer", for: .normal)
                self.plantsButton.setTitle("Plants", for: .normal)
                self.otherButton.setTitle("Other", for: .normal)
                self.successButton.setTitle("# Success", for: .normal)
                self.strandedButton.setTitle("# Stranded", for: .normal)
                self.deadButton.setTitle("# Dead", for: .normal)
                self.commentsTextView.text = ""
                self.photoImage1.image = UIImage(systemName: "camera.fill")
                self.photoImage2.image = UIImage(systemName: "camera.fill")
                self.photoImage3.image = UIImage(systemName: "camera.fill")
                self.photoImage4.image = UIImage(systemName: "camera.fill")
                self.photoImage5.image = UIImage(systemName: "camera.fill")
                
                self.data = Observation()
            } catch {
                print("Error saving data, \(error) END")
            }
            
        })) // Ends closure begun in line 279
        alert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: nil))
        
        present(alert, animated: true)
        alert.view.tintColor = UIColor.black
        
        
    } // Ends doneButtonPressed
    
    
    
    //MARK:- Back button
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
}
//        let alert = UIAlertController(title: "CLEAR ALL ENTRIES AND RETURN TO HOME SCREEN?", message: "", preferredStyle: .alert)
//
//        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action) in
//
//            self.dismiss(animated: true, completion: nil)
//
//
//
//
//    alert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: nil))
//
//    present(alert, animated: true)
//        alert.view.tintColor = UIColor.black
//


//MARK:- Location Extension

extension ObservationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            data.lat = location.coordinate.latitude
            data.lon = location.coordinate.longitude
            data.accuracy = location.horizontalAccuracy
            latitude.text = String(format: "%.7f", data.lat)
            longitude.text = String(format: "%.7f", data.lon)
            accuracy.text = "\(String(format: "%.2f", data.accuracy)) m"
            locationButton.setTitle("Location ✓", for: .normal)
        }
        
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

//MARK:- Image Picker extension

extension ObservationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imageTaken = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            //          Call function to set the image on the obs screen
            //          Call function to generate reference
            //           Maybe instead of saving to realm here just save image to variables imageTaken1 - imageTaken5 and save to realm with the rest of data
            //     Also note after 5 photos they can just replace a photo by tapping on it.
            
            
            let date = Date()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'_'HH_mm_ss"
            
            let imgRef = dateFormatter.string(from: date)
            let imageName = "/\(imgRef).jpg"
            
            var documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]


            documentsDirectoryPath += imageName
            let settingsData: NSData = imageTaken.jpegData(compressionQuality: 1.0)! as NSData
            settingsData.write(toFile: documentsDirectoryPath, atomically: true)
            
            switch image {
            case 1:
                photoImage1.image = imageTaken
                data.image1 = imgRef
            case 2:
                photoImage2.image = imageTaken
                data.image2 = imgRef
            case 3:
                photoImage3.image = imageTaken
                data.image3 = imgRef
            case 4:
                photoImage4.image = imageTaken
                data.image4 = imgRef
            case 5:
                photoImage5.image = imageTaken
                data.image5 = imgRef
            default:
                print("error BOUBOUBOBUOBUBOUBOBUOUBBUBUBO")
            }
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}
