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

class MenuViewController: UIViewController {
    
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
        print("Zone button pressed")
    }
    
    @IBAction func propertyButtonPressed(_ sender: UIButton) {
        print("Property button pressed")
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
        data.nest = !data.nest
        updateButtons(sender: sender, for: data.nest)
    }
    
    @IBAction func trackButtonPressed(_ sender: UIButton) {
        data.track = !data.track
        updateButtons(sender: sender, for: data.track)
    }
    
    @IBAction func turtleButtonPressed(_ sender: UIButton) {
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
    
    //MARK:- Save Data
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        
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
        let saveData = Observation()
        
        saveData.nest = data.nest
        saveData.track = data.track
        saveData.turtle = data.turtle
        saveData.eggs = data.eggs
        saveData.carcass = data.carcass

        saveData.lat = data.lat
        saveData.lon = data.lon
        
        saveData.date = Date()
        
        do {
            try realm.write {
                realm.add(saveData)
            }
            
            //Reset all fields if successfully saved
            
            locationButton.setTitle("Get Location", for: .normal)
            nestButton.setTitle("Nest", for: .normal)
            trackButton.setTitle("Track", for: .normal)
            turtleButton.setTitle("Turtle", for: .normal)
            eggsButton.setTitle("Eggs", for: .normal)
            carcassButton.setTitle("Carcass", for: .normal)
            
            data = Observation()
        } catch {
            print("Error saving data, \(error) END")
        }
        
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

extension MenuViewController: CLLocationManagerDelegate {
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


