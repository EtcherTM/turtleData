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


class ObservationViewController: UIViewController, UITextViewDelegate{
    
    var data = Observation()
    
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
    
    @IBOutlet weak var nestButton: UIButton!
    @IBOutlet weak var existingNestButton: UIButton!
    @IBOutlet weak var turtleButton: UIButton!
    @IBOutlet weak var hatchingButton: UIButton!
    
    @IBOutlet weak var photoImage1: UIImageView!
    @IBOutlet weak var photoImage2: UIImageView!
    @IBOutlet weak var photoImage3: UIImageView!
    @IBOutlet weak var photoImage4: UIImageView!
    @IBOutlet weak var photoImage5: UIImageView!
    
    @IBOutlet weak var commentsTextView: UITextView!
    //    @IBOutlet weak var commentsTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if data.hatchingDetails != nil && data.hatchingDetails?.hatchingExists != false {
                   print("NOT NIL")
                    print(data.hatchingDetails?.hatchingExists)
                   hatchingButton.setTitle("Hatching ✓", for: .normal)
               } else {
                   hatchingButton.setTitle("Hatching?", for: .normal)
               }
    }
    
    func didDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        navigationController?.setNavigationBarHidden(false, animated: animated)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ObsToHatching" {
            let vc = segue.destination as! HatchingViewController
            vc.obs = data
        }
    }
    
//    @IBAction func hatchingCancelButtonPressed(_ unwindSegue: UIStoryboardSegue) {
//    guard let hatchingVC = unwindSegue.source as? HatchingViewController,
//        let myVariable = hatchingVC.hisVariable,
//        print(myVariable) else {
//
//        }
//        let wasThereAHatching = hatchingVC.hatch.hatchingExists else {
//            return
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
        //Get location with CoreLocation
        locationManager.requestLocation()
        sender.setTitle("Getting: hold position . . .", for: .normal)
    }
    
    @IBAction func photoButtonPressed(_ sender: UIButton) {
        
        switch sender.currentTitle ?? "" {
        case "photo1":
            image = 1
        case "photo2":
            image = 2
        case " photo3":
            image = 3
        case "photo4":
            image = 4
        case "photo5":
            image = 5
        default:
            print("DODODODODO")
        }
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func handleGesture(_ sender: UILongPressGestureRecognizer) {
        
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
        
//        if sender.state == .began
//        {
//            let alertController = UIAlertController(title: nil, message:
//                "Long-Press Gesture Detected", preferredStyle: .alert)
//            alertController.addAction(UIAlertAction(title: "OK", style: .default,handler: nil))
//
//            present(alertController, animated: true, completion: nil)
//        }

    }
    @IBAction func nestButtonPressed(_ sender: UIButton) {
        //Probability of nest?
        if !data.nest {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "NEW/PROBABLE NEST", style: .default, handler: { (action) in
                sender.setTitle("New Nest ✓", for: .normal)
                self.data.nestType = "nest"
            }))
            alert.addAction(UIAlertAction(title: "FALSE NEST", style: .default, handler: { (action) in
                self.data.nestType = "false nest"
                sender.setTitle("False Nest ✓", for: .normal)
            }))
            alert.addAction(UIAlertAction(title: "FALSE CRAWL", style: .default, handler: { (action) in
                self.data.nestType = "false crawl"
                sender.setTitle("False Crawl ✓", for: .normal)
                
            }))
    
            
            present(alert, animated: true)
            alert.view.tintColor = UIColor.black
            
        } else {
            sender.setTitle("New Nest?", for: .normal)
            data.nestType = ""
        }
        
        
        data.nest = !data.nest
        
    }
    
    @IBAction func existingNestButtonPressed(_ sender: UIButton) {
        
        if !data.existingNestDisturbed {
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            //            action.setValue(UIColor.orange, forKey: "titleTextColor") Sebo:  Don't know where to put this to make it actually do something.
            
            alert.addAction(UIAlertAction(title: "DISTURBED BY NATURAL CAUSE", style: .default, handler: { (action) in
                
                self.data.existingNestDisturbedType = "disturbed nature"
                sender.setTitle("Disturb/Nature ✓", for: .normal)
                
            }))
            alert.addAction(UIAlertAction(title: "DISTURBED BY HUMAN CAUSE", style: .default, handler: { (action) in
                
                self.data.existingNestDisturbedType = "disturbed human"
                sender.setTitle("Disturb/Human ✓", for: .normal)
                
            }))

            alert.addAction(UIAlertAction(title: "LOST BY NATURAL CAUSE", style: .default, handler: { (action) in
                self.data.existingNestDisturbedType = "lost nature"
                sender.setTitle("Lost/Nature ✓", for: .normal)
                
            }))
            
            alert.addAction(UIAlertAction(title: "LOST BY HUMAN CAUSE", style: .default, handler: { (action) in
                self.data.existingNestDisturbedType = "lost human"
                sender.setTitle("Lost/Human ✓", for: .normal)
                
            }))
            
            alert.addAction(UIAlertAction(title: "MOVED FROM: NATURAL CAUSE", style: .default, handler: { (action) in
                self.data.existingNestDisturbedType = "relocated nature"
                sender.setTitle("Move From/Natu ✓", for: .normal)
                
            }))
            
            alert.addAction(UIAlertAction(title: "MOVED FROM: HUMAN ACTIVITY", style: .default, handler: { (action) in
                self.data.existingNestDisturbedType = "relocated nature"
                sender.setTitle("Move From/Human ✓", for: .normal)
                
            }))
            
            alert.addAction(UIAlertAction(title: "MOVED TO", style: .default, handler: { (action) in
                self.data.nestType = "relocated to"
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
        
        self.performSegue(withIdentifier: "ObsToHatching", sender: self)
        
       
    }

    
    
    
    
    //MARK:- Save Data
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "SAVE THIS OBSERVATION AND CLEAR ALL FIELDS?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (_) in
            
            self.data.comments = self.commentsTextView.text ?? ""
            
            // creat id
            var id = "\(self.data.zoneLocation)-" != "" ? "\(self.data.zoneLocation)-": "-"
            
            if self.data.nest { id.append(self.data.nestType == "nest" ? "N" : "F") }
            if self.data.existingNestDisturbed { id.append(self.data.existingNestDisturbedType == "disturbed" ? "D" : "R") }
            id.append(self.data.hatchingDetails != nil ? "H" : "")
            id.append(self.data.turtle ? "T" : "")
            
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
                self.locationButton.setTitle("Get GPS Location", for: .normal)
                self.nestButton.setTitle("Nest?", for: .normal)
                self.existingNestButton.setTitle("Disturb/Reloc?", for: .normal)
                self.turtleButton.setTitle("Turtle?", for: .normal)
                self.hatchingButton.setTitle("Hatching", for: .normal)
                self.zoneButton.setTitle("Zone?", for: .normal)
                self.propertyButton.setTitle("Property/Lot?", for: .normal)
                self.commentsTextView.text = ""
//                self.photoButton.setTitle("", for: .normal)  What's wrong here?
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
            locationButton.setTitle("\(String(format: "%.2f", data.lat)), \(String(format: "%.2f", data.lon)), ± \(String(format: "%.2f", data.accuracy))m", for: .normal)
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
//            print(documentsDirectoryPath)
//            self.data.docDirPath = self.documentsDirectoryPath THIS IS INEFFECTIVE

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
