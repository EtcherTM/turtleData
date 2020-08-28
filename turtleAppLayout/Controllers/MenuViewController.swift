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
    
    let zones = ["A", "B", "C", "D", "E", "F", "G"]
    
    let propertiesInA =
        [("A.1", "Far S End/Pont Gue Gue"),
         ("A.2", "Lookout"),
         ("A.3", "Grey/glass 3-story apt bldg"),
         ("A.4", "S of public access w/ crane"),
         ("A.5", "White apts N of public access"),
         ("A.6", "Grey house lot S of EU res"),
         ("A.7", "EU Residence"),
         ("A.8", "Mme Jovic’s lot (2 houses)"),
         ("A.9", "Light pink flower wall"),
         ("A.10", "White house wooden shutters"),
         ("A.11", "Wooden gate/Beware of dog sign"),
         ("A.12", "White cement wall/red rocks"),
         ("A.13", "Apartment bldg with purple wall")]
    
    let propertiesInB =
        [("B.1", "Yellow house S of Atlantique"),
         ("B.2", "Residence Atlantique"),
         ("B.3", "Maison Alliance"),
         ("B.4", "Empty lot N of Maison Alliance"),
         ("B.5", "Red tiles house/Turtle sign"),
         ("B.6", "Maye Beach - south"),
         ("B.7", "Maye beach - north")]
    
    let propertiesInC =
        [("C.1", "Residence Bora Bora"),
         ("C.2", "Tall Building"),
         ("C.3", "Flower wall N of tall bldg"),
         ("C.4", "Empty lot S of Total res."),
         ("C.5", "Total residence"),
         ("C.6", "Fish tiles house"),
         ("C.7", "White wall S of Russians"),
         ("C.8", "Russian residence"),
         ("C.9", "Pink wall (next to flower wall)"),
         ("C.10", "Pink flower bricks/wall"),
         ("C.11", "Building 5A / Bldg IMP"),
         ("C.12", "Pink wall/Residence Tahiti"),
         ("C.13", "Yellow EU house")]
    
    let propertiesInD =
        [("D.1", "Red house N of yellow EU house"),
         ("D.2", "Tropicana"),
         ("D.3", "Petit bar"),
         ("D.4", "UN residence"),
         ("D.5", "Bldg No. 5/Green tiles bldg"),
         ("D.6", "Empty lot N of green tiles bldg"),
         ("D.7", "House two lots N of green tiles bldg"),
         ("D.8", "House 1 lot S of military event space"),
         ("D.9", "Military event/grey military housing")]

    let propertiesInE =
        [("E.1", "Off-white military housing"),
         ("E.2", "Peach military housing"),
         ("E.3", "2 story military housing"),
         ("E.4", "Yellow military housing"),
         ("E.5", "Spanish residence"),
         ("E.6", "White bldg/glass fence"),
         ("E.7", "Twin blue/white bldgs"),
         ("E.8", "Rounded yellow building (x airport)"),
         ("E.9", "Lot/construct. N of twin blue bldgs"),
         ("E.10", "Large yellow apt bldg S of KFC lot")]

    let propertiesInF =
        [("F.1", "Vacant/KFC lot - south end"),
         ("F.2", "Vacant/KFC lot - north end"),
         ("F.3", "Fancy blue tile bldg"),
         ("F.4", "Inactive Contruction"),
         ("F.5", "Wall with white posts/brown"),
         ("F.6", "Orange wall"),
         ("F.7", "Residence du Phare"),
         ("F.8", "Empty lot N of Res. du Phare"),
         ("F.9", "US residence"),
         ("F.10", "Parrot Building"),
         ("F.11", "Unknown N of Parrot Bldg"),
         ("F.12", "Grey wall"),
         ("F.13", "Claire/Air France"),
         ("F.14", "Unknown S of Party Place"),
         ("F.15", "Party Place"),
         ("F.16", "Tomas’ fishing pool"),
         ("F.17", "Chain fence"),
         ("F.18", "Saudi residence")]

    let propertiesInG =
        [("G.1", "Small house"),
         ("G.2", "Rose Vents"),
         ("G.3", "Ivory Coast Embassy"),
         ("G.4", "Abandoned Lot"),
         ("G.5", "Cercle Pompidou"),
         ("G.6", "Saudi Embassy"),
         ("G.7", "Hotel Oceane"),
         ("G.8", "Brazil residence"),
         ("G.9", "Talhassa"),
         ("G.10", "Blue tiles/waves fence"),
         ("G.11", "Turkey"),
         ("G.12", "More monster"),
         ("G.13", "Monster"),
         ("G.14", "Maisha"),
         ("G.15", "Picket Fence 2"),
         ("G.16", "Picket Fence 1"),
         ("G.17", "House with tennis court"),
         ("G.18", "Anonymous lot"),
         ("G.19", "Chicken swamp lot"),
         ("G.20", "Stephanie’s")]
    
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
        
        let alert = UIAlertController(title: "Select a zone", message: "", preferredStyle: .alert)
        
        for zone in zones {
            let action = UIAlertAction(title: "Zone \(zone)", style: .default) { (eee) in
                sender.setTitle("Zone: \(zone) ✓", for: .normal)
            }
            alert.addAction(action)
        }
        
        present(alert, animated: true)
        
        
    }
    
    @IBAction func propertyButtonPressed(_ sender: UIButton) {
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


