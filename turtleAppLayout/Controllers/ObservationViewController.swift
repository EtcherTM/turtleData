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
    
    
    var image = [UIImage]()
    
    @IBOutlet weak var zoneButton: UIButton!
    @IBOutlet weak var propertyButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    
    @IBOutlet weak var nestButton: UIButton!
    @IBOutlet weak var disturbedButton: UIButton!
    @IBOutlet weak var turtleButton: UIButton!
    @IBOutlet weak var hatchingButton: UIButton!

    @IBOutlet weak var commentsTextView: UITextView!
//    @IBOutlet weak var commentsTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func didDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        self.commentsTextView.delegate = self
        
//        if let data  = data {
//          title = "Edit \(data.id)"
//
//          fillTextFields()
//        } else {
//          title = "Add New Observation"
//        }

        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    
    func fillTextFields() {
      commentsTextView.text = data.comments
//      categoryTextField.text = specimen.category.name
//      descriptionTextField.text = specimen.specimenDescription
//
//      selectedCategory = specimen.category
    }

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
                alert.addAction(UIAlertAction(title: "\(property.0) : \(property.1)", style: .default, handler: { (eee) in
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
    //        Need an alert -- "Wait 10-15 seconds before moving"
//        let latAsStr = String(format: "%.2f", data.lat)
//        let lonAsStr = String(format: "%.2f", data.lon)
                
//        }
//        sender.setTitle("\(latAsStr), \(lonAsStr), Accuracy: \(accessibilityAssistiveTechnologyFocusedIdentifiers())", for: .normal)
    }
    
    @IBAction func photoButtonPressed(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
        sender.setTitle("✓", for: .normal)
    }
    
    @IBAction func nestButtonPressed(_ sender: UIButton) {
        //Probability of nest?
        if !data.nest {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "NEW/PROBABLE", style: .default, handler: { (action) in
                sender.setTitle("New/Prob ✓", for: .normal)
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
            sender.setTitle("Nest?", for: .normal)
            data.nestType = ""
        }
        
        
        data.nest = !data.nest
        
    }
    
    @IBAction func disturbedButtonPressed(_ sender: UIButton) {
        
        if !data.disturbed {

               let alert = UIAlertController(title: "DISTURBED OR RELOCATED?", message: "", preferredStyle: .alert)
//            action.setValue(UIColor.orange, forKey: "titleTextColor") Sebo:  Don't know where to put this to make it actually do something.
               
               alert.addAction(UIAlertAction(title: "DISTURBED", style: .default, handler: { (action) in

                   self.data.disturbedOrRelocated = "disturbed"
                   sender.setTitle("Disturbed nest ✓", for: .normal)

               }))
               alert.addAction(UIAlertAction(title: "RELOCATED", style: .default, handler: { (action) in
                   self.data.disturbedOrRelocated = "relocated"
                   sender.setTitle("Relocated nest ✓", for: .normal)


               }))
               
               present(alert, animated: true)
//            YAY!  MAGIC!
                alert.view.tintColor = UIColor.black

           } else {
               sender.setTitle("Disturb/Reloc?", for: .normal)
               data.disturbedOrRelocated = ""
           }
           data.disturbed = !data.disturbed
        
    }
    
    
    
    
    @IBAction func turtleButtonPressed(_ sender: UIButton) {
        if !data.turtle {

            let alert = UIAlertController(title: "DEAD OR ALIVE?", message: "", preferredStyle: .alert)
            
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
            sender.setTitle("Turtle?", for: .normal)
            data.turtleType = ""
        }
        data.turtle = !data.turtle
        
    }
    
    @IBAction func hatchingButtonPressed(_ sender: UIButton) {
        //Number of eggs?
        if !data.hatching {

            let alert = UIAlertController(title: "SUCCESSFUL HATCHING?", message: "", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "SUCCESS", style: .default, handler: { (action) in
                self.data.hatchingType = "success"
                sender.setTitle("Success Hatch ✓", for: .normal)
            }))
            alert.addAction(UIAlertAction(title: "FAIL", style: .default, handler: { (action) in
                self.data.hatchingType = "fail"
                sender.setTitle("Failed Hatching ✓", for: .normal)
            }))
            
            present(alert, animated: true)
            alert.view.tintColor = UIColor.black

        } else {
            sender.setTitle("Hatching?", for: .normal)
            data.hatchingType = ""
        }
        data.hatching = !data.hatching
    }
    
    
 
    
    
    //MARK:- Save Data
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "SAVE THIS OBSERVATION AND CLEAR ALL FIELDS?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (eee) in
            
            self.data.comments = self.commentsTextView.text ?? ""
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
                self.commentsTextView.text = ""
//                self.photoButton.setTitle("", for: .normal)  What's wrong here?
                
                
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
            print("Location accuracy is \(location.horizontalAccuracy)")
//
//        if (location.horizontalAccuracy < 0)
//        {
//            print("No Signal")
//        }
//        else if (location.horizontalAccuracy > 163)
//        {
//            print("Poor accuracy")
//        }
//        else if (location.horizontalAccuracy > 48)
//        {
//            print("Accurate w/i 48 m")
//        }
//        else
//        {
////          
            
            
            data.lat = location.coordinate.latitude
            data.lon = location.coordinate.longitude
            let latAsStr = String(format: "%.2f", data.lat)
            let lonAsStr = String(format: "%.2f", data.lon)
            let accAsStr = String(format: "%.1f", location.horizontalAccuracy)
            locationButton.setTitle("\(latAsStr), \(lonAsStr), Accuracy: \(accAsStr)", for: .normal)
            
            print(data.lat)
            print(data.lon)
            
            
//            Need a notification for when it actually get location, how long does it take?
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
                print("NO MORE IMAGE STORAGE SPACE AVAILABLE")
            }
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}
