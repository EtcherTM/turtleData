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


class ObservationViewController: UIViewController {
    
    var data = Observation()
    
    let realm = try! Realm()
    let db = Firestore.firestore()
    
    let storage = Storage.storage()
    
    let locationManager = CLLocationManager()
    
    let imagePicker = UIImagePickerController()
    
    let defaults = UserDefaults.standard
    //Setting user id if doesn't exist, replace with the log + alert
    var userID: String = ""
    
    
    var image = [UIImage]()
    
    @IBOutlet weak var zoneButton: UIButton!
    @IBOutlet weak var propertyButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    
    @IBOutlet weak var nestButton: UIButton!
    @IBOutlet weak var disturbedButton: UIButton!
    @IBOutlet weak var turtleButton: UIButton!
    @IBOutlet weak var hatchingButton: UIButton!

    @IBOutlet weak var commentsTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func didDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
    }
    
    //MARK:- IBActions: Data Entry
    @IBAction func zoneButtonPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Select a zone", message: "", preferredStyle: .alert)
 
        
        for zone in K.zones {
            let action = UIAlertAction(title: zone, style: .default) { (_) in
                if self.data.zoneLocation != zone {
                    self.data.property = ""
                    self.propertyButton.setTitle("Choose\nProperty", for: .normal)
                }
                sender.setTitle("Zone: \(zone) ✓", for: .normal)
                self.data.zoneLocation = zone
                
            }
            alert.addAction(action)
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            sender.setTitle("Choose\nzone", for: .normal)
            self.data.zoneLocation = ""
            self.data.property = ""
            self.propertyButton.setTitle("Choose\nProperty", for: .normal)
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
            let alert = UIAlertController(title: "Select zone first", message: "", preferredStyle: .alert)
            
//            alert.setValue(messageMutableString, forKey: "attributedMessage")
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
        }
        
        if let propertyList = propertyList {
            let alert = UIAlertController(title: "Select a property from zone \(data.zoneLocation)", message: "", preferredStyle: .alert)
        
            
            
            for property in propertyList {
                alert.addAction(UIAlertAction(title: "\(property.0) : \(property.1)", style: .default, handler: { (eee) in
                    self.data.property = property.0
                    sender.setTitle("\(property.0) : \(property.1)", for: .normal)
                }))
            }
                      
            alert.addAction(UIAlertAction(title: "Clear Selection", style: .cancel, handler: { (_) in
                sender.setTitle("Choose\nProperty", for: .normal)

            }))
            present(alert, animated: true)
            alert.view.tintColor = UIColor.black

        }

    }
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        //Get location with CoreLocation
        locationManager.requestLocation()
        sender.setTitle("Got Location ✓", for: .normal)
    }
    
    @IBAction func photoButtonPressed(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
        sender.setTitle("✓", for: .normal)
    }
    
    @IBAction func nestButtonPressed(_ sender: UIButton) {
        //Probability of nest?
        if !data.nest {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "New/Prob", style: .default, handler: { (action) in
                sender.setTitle("New/Prob ✓", for: .normal)
                self.data.nestType = "nest"
            }))
            alert.addAction(UIAlertAction(title: "False Nest", style: .default, handler: { (action) in
                self.data.nestType = "false nest"
                sender.setTitle("False Nest ✓", for: .normal)
            }))
            alert.addAction(UIAlertAction(title: "False Crawl", style: .default, handler: { (action) in
                self.data.nestType = "false crawl"
                sender.setTitle("False Crawl ✓", for: .normal)

            }))
            
            present(alert, animated: true)
            alert.view.tintColor = UIColor.black

        } else {
            sender.setTitle("Nest", for: .normal)
            data.nestType = ""
        }
        
        
        data.nest = !data.nest
        
    }
    
    @IBAction func disturbedButtonPressed(_ sender: UIButton) {
        
        if !data.disturbed {

               let alert = UIAlertController(title: "Disturbed or Relocated?", message: "", preferredStyle: .alert)
//            action.setValue(UIColor.orange, forKey: "titleTextColor") Sebo:  Don't know where to put this to make it actually do something.
               
               alert.addAction(UIAlertAction(title: "Disturbed", style: .default, handler: { (action) in

                   self.data.disturbedOrRelocated = "disturbed"
                   sender.setTitle("Disturbed nest ✓", for: .normal)

               }))
               alert.addAction(UIAlertAction(title: "Relocated", style: .default, handler: { (action) in
                   self.data.disturbedOrRelocated = "relocated"
                   sender.setTitle("Relocated nest ✓", for: .normal)


               }))
               
               present(alert, animated: true)
//            YAY!  MAGIC!
                alert.view.tintColor = UIColor.black

           } else {
               sender.setTitle("Existing Nest", for: .normal)
               data.disturbedOrRelocated = ""
           }
           data.disturbed = !data.disturbed
        
    }
    
    
    
    
    @IBAction func turtleButtonPressed(_ sender: UIButton) {
        if !data.turtle {

            let alert = UIAlertController(title: "Dead or Alive?", message: "", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Dead", style: .default, handler: { (action) in
                self.data.turtleType = "dead"
                sender.setTitle("Dead Adult ✓", for: .normal)
            }))
            alert.addAction(UIAlertAction(title: "Alive", style: .default, handler: { (action) in
                self.data.turtleType = "live"
                sender.setTitle("Live Adult ✓", for: .normal)
            }))
            
            present(alert, animated: true)
            alert.view.tintColor = UIColor.black

        } else {
            sender.setTitle("Turtle", for: .normal)
            data.turtleType = ""
        }
        data.turtle = !data.turtle
        
    }
    
    @IBAction func hatchingButtonPressed(_ sender: UIButton) {
        //Number of eggs?
        if !data.hatching {

            let alert = UIAlertController(title: "Succesful hatching?", message: "", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Successful", style: .default, handler: { (action) in
                self.data.hatchingType = "success"
                sender.setTitle("Success Hatch ✓", for: .normal)
            }))
            alert.addAction(UIAlertAction(title: "Failed", style: .default, handler: { (action) in
                self.data.hatchingType = "fail"
                sender.setTitle("Failed Hatching ✓", for: .normal)
            }))
            
            present(alert, animated: true)
            alert.view.tintColor = UIColor.black

        } else {
            sender.setTitle("Hatching", for: .normal)
            data.hatchingType = ""
        }
        data.hatching = !data.hatching
    }
    
    //MARK:- Save Data
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Save this observation and clear all fields?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (eee) in
            
            self.data.comments = self.commentsTextField.text ?? ""
            
            var id = self.data.zoneLocation != "" ? self.data.zoneLocation : "-"
            
            if self.data.nest { id.append(self.data.nestType == "nest" ? "N" : "F") }
            if self.data.disturbed { id.append(self.data.disturbedOrRelocated == "disturbed" ? "D" : "R") }
            id.append(self.data.hatching ? "H" : "")
            id.append(self.data.turtle ? "T" : "")
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMddHHmmss"
            
            id.append(dateFormatter.string(from: Date()))
            id.append(self.defaults.string(forKey: "userID") ?? "NOUSER")
            self.data.id = id
            
            do {
                try self.realm.write {
                    self.realm.add(self.data)
                }
                
                //Reset all fields if successfully saved
                self.locationButton.setTitle("Get GPS Location", for: .normal)
                self.nestButton.setTitle("Nest", for: .normal)
                self.disturbedButton.setTitle("Disturbed", for: .normal)
                self.turtleButton.setTitle("Adult Turtle", for: .normal)
                self.hatchingButton.setTitle("Hatching", for: .normal)
                self.zoneButton.setTitle("Choose\nZone", for: .normal)
                self.propertyButton.setTitle("Choose\nProperty", for: .normal)
                self.commentsTextField.text = ""
                
                self.data = Observation()
            } catch {
                print("Error saving data, \(error) END")
            }
            
        })) // Ends closure begun in line 279
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        present(alert, animated: true)
        alert.view.tintColor = UIColor.black

    
    } // Ends doneButtonPressed
   
    
    
    //MARK:- Back button
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        
        let alert = UIAlertController(title: "Discard all entries and return to Home Screen?", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            
            self.dismiss(animated: true, completion: nil)

        }))
        
    
    
    alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
    
    present(alert, animated: true)
        alert.view.tintColor = UIColor.black

    
        } //Ends backButtonPressed function

            
            //Read from Realm

//            let observations = self.realm.objects(Observation.self)
//
//
//            for obs in observations {
//
//                var upload: Dictionary<String, Any> = [:]
//
//                var type = [String]()
//
//                let images = [obs.image1, obs.image2, obs.image3, obs.image4, obs.image5]
//
//                if obs.turtle {type.append(obs.turtleType)}
//                if obs.disturbed {type.append("disturbed")}
//                if obs.nest {type.append(obs.nestType)}
//                if obs.hatching {type.append(obs.hatchingType)}
//
//                upload["date"] = obs.date
//                upload["property"] = obs.property != "" ? obs.property : nil
//                upload["zone"] = obs.zoneLocation != "" ? obs.zoneLocation : nil
//                upload["coords"] = obs.lat != 0 && obs.lon != 0 ? [obs.lat, obs.lon] : nil
//                upload["comments"] = obs.comments != "" ? obs.comments : nil
//                upload["type"] = type != [] ? type : nil
//                upload["userid"] = self.defaults.string(forKey: "userID") ?? ""
//                upload["imageURLS"] = obs.id
//
//
//                self.db.collection("observations").addDocument(data: upload) { (error) in
//                    if let error = error {
//                        print("Error saving to Firebase, \(error)")
//                    } else {
//                        //Destroy Realm safely, only if successfully created to FireBase? MAYBE?
//                        do {
//                            try self.realm.write {
//                                self.realm.delete(obs)
//                            }
//                        } catch {
//                            print("Error deleting Realm: \(error)")
//
//                        }
//                    }
//                }
//
//                let storageRef = self.storage.reference()
//                for image in 0...4 {
//                    if images[image] != "" {
//                        if var documentsPathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//                            //This gives you the URL of the path
//                            documentsPathURL.appendPathComponent("\(images[image]).jpg")
//                            let imageRef = storageRef.child("\(obs.id)/image\(image).jpg")
//                            print("The imageRef is \(imageRef)")
//
//                            print("documentsPathURL \(documentsPathURL)")
//
//                            imageRef.putFile(from: documentsPathURL, metadata: nil)
//                        }
//                    }
//                }
//            }

//
//    }
//
}

//MARK:- Alert Action Extension -- doesn't go anything?  do I need to call it somehow?

extension UIAlertAction {
    var titleTextColor: UIColor? {
        get {
            return self.value(forKey: "titleTextColor") as? UIColor
        } set {
            
            self.setValue(UIColor.black, forKey: "titleTextColor")
        }
    }
}

//MARK:- Location Extension

extension ObservationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            data.lat = location.coordinate.latitude
            data.lon = location.coordinate.longitude
        }
        
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

//MARK:- Photo taker thing

extension ObservationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageTaken = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let date = Date()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'_'HH_mm_ss"
            
            let imgRef = dateFormatter.string(from: date)
            
            let imageName = "/\(imgRef).jpg"
            
            
            
            var documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            print(documentsDirectoryPath)
            documentsDirectoryPath += imageName
            let settingsData: NSData = imageTaken.jpegData(compressionQuality: 1.0)! as NSData
            settingsData.write(toFile: documentsDirectoryPath, atomically: true)
            
            if data.image1 == "" {
                data.image1 = imgRef
            } else if data.image2 == "" {
                data.image2 = imgRef
            } else if data.image3 == "" {
                data.image3 = imgRef
            } else if data.image4 == "" {
                data.image4 = imgRef
            } else if data.image5 == "" {
                data.image5 = imgRef
            } else {
                print("No more image storage ")
            }
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}
