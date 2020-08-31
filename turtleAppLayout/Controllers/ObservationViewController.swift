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
            let action = UIAlertAction(title: "Zone \(zone)", style: .default) { (_) in
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
            let alert = UIAlertController(title: "Please select a zone first", message: "", preferredStyle: .alert)
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
            present(alert, animated: true)
        }
        
        
//        print("Property button pressed")
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
            
            alert.addAction(UIAlertAction(title: "New Nest", style: .default, handler: { (action) in
                sender.setTitle("New Nest", for: .normal)
                self.data.nestType = "nest"
            }))
            alert.addAction(UIAlertAction(title: "False Nest", style: .default, handler: { (action) in
                self.data.nestType = "false nest"
                sender.setTitle("False Nest", for: .normal)
            }))
            alert.addAction(UIAlertAction(title: "False Crawl", style: .default, handler: { (action) in
                self.data.nestType = "false crawl"
                sender.setTitle("False Crawl", for: .normal)

            }))
            
            present(alert, animated: true)
        } else {
            sender.setTitle("Nest", for: .normal)
            data.nestType = ""
        }
        
        
        data.nest = !data.nest
        
    }
    
    @IBAction func disturbedButtonPressed(_ sender: UIButton) {
        data.disturbed = !data.disturbed
        updateButtons(sender: sender, for: data.disturbed)
    }
    
    @IBAction func turtleButtonPressed(_ sender: UIButton) {
        if !data.turtle {

            let alert = UIAlertController(title: "Adult or babies?", message: "", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Adult", style: .default, handler: { (action) in
                self.data.turtleType = "adult"
                sender.setTitle("Adult", for: .normal)
            }))
            alert.addAction(UIAlertAction(title: "Babies", style: .default, handler: { (action) in
                self.data.turtleType = "baby"
                sender.setTitle("Babies", for: .normal)
            }))
            
            present(alert, animated: true)
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
            
            alert.addAction(UIAlertAction(title: "Success", style: .default, handler: { (action) in
                self.data.hatchingType = "success"
                sender.setTitle("Hatching: successful", for: .normal)
            }))
            alert.addAction(UIAlertAction(title: "Fail", style: .default, handler: { (action) in
                self.data.hatchingType = "fail"
                sender.setTitle("Hatching: failure", for: .normal)
            }))
            
            present(alert, animated: true)
        } else {
            sender.setTitle("Hatching", for: .normal)
            data.hatchingType = ""
        }
        data.hatching = !data.hatching
    }
    
    //MARK:- Save Data
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Save this observation and return to main menu?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (eee) in
            
            self.data.comments = self.commentsTextField.text ?? ""
            do {
                try self.realm.write {
                    self.realm.add(self.data)
                }
                
                //Reset all fields if successfully saved
                
                self.locationButton.setTitle("Get Location", for: .normal)
                self.nestButton.setTitle("Nest", for: .normal)
                self.disturbedButton.setTitle("Disturbed", for: .normal)
                self.turtleButton.setTitle("Turtle", for: .normal)
                self.hatchingButton.setTitle("Hatching", for: .normal)
                self.zoneButton.setTitle("Choose\nZone", for: .normal)
                self.propertyButton.setTitle("Choose\nProperty", for: .normal)
                self.commentsTextField.text = ""
                
                self.data = Observation()
            } catch {
                print("Error saving data, \(error) END")
            }
            
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        present(alert, animated: true)
        
    }
    
    //MARK:- Sync
    
    @IBAction func syncButtonPressed(_ sender: UIButton) {
        //Probably should put a confirmation alert
        
        let alert = UIAlertController(title: "Are you sure you want to upload your data to the database?", message: "This will delete all local observations", preferredStyle: .alert)
        
        //Read from Realm
        let observations = realm.objects(Observation.self)
        
        
        for obs in observations {
            //Create to Firebase
            //Do we need FirebaseAuth?
            
            var upload: Dictionary<String, Any> = [:]
            
            var type = [String]()
            
            if obs.turtle {type.append(obs.turtleType)}
            if obs.disturbed {type.append("disturbed")}
            if obs.nest {type.append(obs.nestType)}
            if obs.hatching {type.append(obs.hatchingType)}
            
//            if obs.nest {type.append("Nest")}
//            if obs.track {type.append("Track")}
//            if obs.eggs {type.append("Eggs")}
//            if obs.carcass {type.append("Carcass")}
            
            
            upload["date"] = obs.date
            upload["property"] = obs.property != "" ? obs.property : obs.zoneLocation != "" ? obs.zoneLocation : nil
            upload["coords"] = obs.lat != 0 && obs.lon != 0 ? [obs.lat, obs.lon] : nil
            upload["comments"] = obs.comments != "" ? obs.comments : nil
            upload["type"] = type != [] ? type : nil
            
            
            db.collection("observations").addDocument(data: upload) { (error) in
                if let error = error {
                    print("Error saving to Firebase, \(error)")
                } else {
                    //Destroy Realm safely, only if successfully created to FireBase? MAYBE?
                    do {
                        try self.realm.write {
                            self.realm.delete(obs)
                        }
                    } catch {
                        print("Error deleting Realm: \(error)")
                    }
                }
            }
            
            
        }
    }
    
    //MARK:- Helper Functions
    
    func updateButtons(sender: UIButton, for selected: Bool) {
        if selected {
            sender.setTitle(sender.currentTitle! + "✓", for: .normal)
        } else {
            sender.setTitle(String((sender.currentTitle?.dropLast())!), for: .normal)
        }
    }
    
}

//MARK:- Location Extention

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
            UIImageWriteToSavedPhotosAlbum(imageTaken, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            print(error)
        }
    }
    
}
