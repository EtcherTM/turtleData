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
import Firebase

class ObservationViewController: UIViewController {
    
    var data = Observation()
    
    let realm = try! Realm()
    let db = Firestore.firestore()
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var nestButton: UIButton!
    @IBOutlet weak var trackButton: UIButton!
    @IBOutlet weak var turtleButton: UIButton!
    @IBOutlet weak var eggsButton: UIButton!
    @IBOutlet weak var carcassButton: UIButton!
    @IBOutlet weak var otherTypeButton: UIButton!
    @IBOutlet weak var zoneButton: UIButton!
    @IBOutlet weak var propertyButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
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
        } else {
            print("nother")
        }
        
        
//        print("Property button pressed")
    }
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        //Get location with CoreLocation
        locationManager.requestLocation()
        sender.setTitle("Got Location! ✓", for: .normal)
    }
    
    @IBAction func photoButtonPressed(_ sender: UIButton) {
        //Take Photo
        
        //WARNING! Firestore has a maximum limit to document sizes, 1MB, which is really small for pictures. There's something call Cloud Storage for Firestore, but I'm not sure about the pricing for that. It's recommended online to use Cloud Storage to store the photos themselves and keep just the download links in Firebase, kind of like how we currently keep the photos in a Drive folder and just put links to them in the spreadsheet.
    }
    
    @IBAction func nestButtonPressed(_ sender: UIButton) {
        //Probability of nest?
        if !data.nest {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "New: Confirmed nest", style: .default, handler: { (action) in
                sender.setTitle("New: Confirmed nest", for: .normal)
                self.data.nestProbability = "1"
            }))
            alert.addAction(UIAlertAction(title: "New: Probable nest", style: .default, handler: { (action) in
                self.data.nestProbability = "2"
                sender.setTitle("New: Probable nest", for: .normal)
            }))
            alert.addAction(UIAlertAction(title: "New: Possible nest", style: .default, handler: { (action) in
                self.data.nestProbability = "3"
                sender.setTitle("New: Possible nest", for: .normal)

            }))
            alert.addAction(UIAlertAction(title: "New: Incomplete nest", style: .default, handler: { (action) in
                self.data.nestProbability = "4"
               sender.setTitle("New: Incomplete nest", for: .normal)
                
            }))
            alert.addAction(UIAlertAction(title: "Old: Disturbed nest ", style: .default, handler: { (action) in
                sender.setTitle("Old: Disturbed nest", for: .normal)
                self.data.nestProbability = "-"
            }))
            
            present(alert, animated: true)
        }
        
        
        data.nest = !data.nest
        updateButtons(sender: sender, for: data.nest)
        
    }
    
    @IBAction func trackButtonPressed(_ sender: UIButton) {
        data.track = !data.track
        updateButtons(sender: sender, for: data.track)
    }
    
    @IBAction func turtleButtonPressed(_ sender: UIButton) {
        if !data.turtle {
            var textField = UITextField()
            
            let alert = UIAlertController(title: "Adult or baby?", message: "Change # if more than 1", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Adult", style: .default, handler: { (action) in
                self.data.turtleType = "adult"
                self.data.turtleCount = Int(textField.text ?? "1") ?? 1
                sender.setTitle("Adults: \(self.data.turtleCount)", for: .normal)
            }))
            alert.addAction(UIAlertAction(title: "Baby", style: .default, handler: { (action) in
                self.data.turtleType = "baby"
                self.data.turtleCount = Int(textField.text ?? "1") ?? 1
                sender.setTitle("Babies: \(self.data.turtleCount)", for: .normal)
            }))
            alert.addTextField { (field) in
                textField = field
                textField.placeholder = "1"
            }
            
            present(alert, animated: true)
        }
        data.turtle = !data.turtle
        updateButtons(sender: sender, for: data.turtle)
    }
    
    @IBAction func eggsButtonPressed(_ sender: UIButton) {
        //Number of eggs?
        data.eggs = !data.eggs
        updateButtons(sender: sender, for: data.eggs)
    }
    
    @IBAction func carcassButtonPressed(_ sender: UIButton) {
        data.carcass = !data.carcass
        updateButtons(sender: sender, for: data.carcass)
    }
    
    @IBAction func otherTypeButtonPressed(_ sender: UIButton) {
    
        var textField = UITextField()
    
        let alert = UIAlertController(title: "Enter other type of observation", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            self.otherTypeButton.setTitle(textField.text ?? "", for: .normal)
        }
        
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
        }
        
        present(alert, animated: true)
//        data.otherType = !data.otherType
//        updateButtons(sender: sender, for: data.otherType)
        
    }
    //MARK:- Save Data
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Save this observation and return to main menu?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (eee) in
            let saveData = Observation()
            
            saveData.nest = self.data.nest
            saveData.track = self.data.track
            saveData.turtle = self.data.turtle
            saveData.eggs = self.data.eggs
            saveData.carcass = self.data.carcass

            saveData.lat = self.data.lat
            saveData.lon = self.data.lon
            
            saveData.date = Date()
            saveData.zoneLocation = self.data.zoneLocation
            saveData.property = self.data.property
            
            
            do {
                try self.realm.write {
                    self.realm.add(saveData)
                }
                
                //Reset all fields if successfully saved
                
                self.locationButton.setTitle("Get Location", for: .normal)
                self.nestButton.setTitle("Nest", for: .normal)
                self.trackButton.setTitle("Track", for: .normal)
                self.turtleButton.setTitle("Turtle", for: .normal)
                self.eggsButton.setTitle("Eggs", for: .normal)
                self.carcassButton.setTitle("Carcass", for: .normal)
                self.zoneButton.setTitle("Choose Zone", for: .normal)
                self.propertyButton.setTitle("Choose Property", for: .normal)
                
                self.data = Observation()
            } catch {
                print("Error saving data, \(error) END")
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        present(alert, animated: true)
        
//        print("Nest: \(data.nest)")
//        print("Track: \(data.track)")
//        print("Turtle: \(data.turtle)")
//        print("Eggs: \(data.eggs)")
//        print("Carcass: \(data.carcass)")
//
//
//        print(data.lat)
//        print(data.lon)
        
        //Must be an easier way to copy
        
        
    }
    
    //MARK:- Sync
    
    @IBAction func syncButtonPressed(_ sender: UIButton) {
        //Probably should put a confirmation alert
        
        //Read from Realm
        let observations = realm.objects(Observation.self)
        
        
        for obs in observations {
            //Create to Firebase
            //Do we need FirebaseAuth?
            
            var type = [String]()
            
            if obs.nest {type.append("Nest")}
            if obs.track {type.append("Track")}
            if obs.turtle {type.append("Turtle")}
            if obs.eggs {type.append("Eggs")}
            if obs.carcass {type.append("Carcass")}
            
            var coords = [Double]()
            
            if obs.lat != 0 && obs.lon != 0 { coords = [obs.lat, obs.lon] }
            
            db.collection("observations").addDocument(data: [
                "zone": obs.zoneLocation,
                "property": obs.property,
                "type": type,
                "coords": coords,
                "date": obs.date
            ]) { (error) in
                if let error = error {
                    print("Error saving to Firebase, \(error)")
                } else {
                    //Destroy Realm safely, only if successfully uploaded
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

/*

 
 */


