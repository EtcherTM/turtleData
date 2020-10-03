//
//  ViewController.swift
//  turtleAppLayout
//
//  Created by Olivia James on 9/1/20.
//  Copyright © 2020 Sebastien James. All rights reserved.
//

import UIKit
import RealmSwift
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage

protocol ButtonUpdater {
    func changeButtonLabel()
}

class HomeViewController: UIViewController, ButtonUpdater {
    
    func changeButtonLabel() {
        noActivityButton.setTitle(noActivityValue, for: .normal)
        
    }
    
    @IBOutlet weak var noActivityButton: UIButton!
    
    let realm = try! Realm()
    let defaults = UserDefaults.standard
    let db = Firestore.firestore()
    let storage = Storage.storage()
    var data = Observation()
    var noActivityValue: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        
    }
    
    
    @IBAction func newObsButtonPressed(_ sender: UIButton) {
        if defaults.value(forKey: "userID") as? String != "" {
            performSegue(withIdentifier: "HomeToObs", sender: self)
        } else {
            let alert = UIAlertController(title: "NO USER ID ENTERED. GO BACK TO WELCOME SCREEN AND ENTER USER ID FIRST", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "DISMISS", style: .cancel, handler: nil))
            present(alert, animated: true)
            alert.view.tintColor = UIColor.black
        }
        
    }
    
    
    
    @IBAction func reviewPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "HomeToList", sender: self)
        
        
        //        let observations = self.realm.objects(Observation.self)
        //
        //        let alert = UIAlertController(title: "Select an observation to review", message: "", preferredStyle: .alert)
        //
        //        for obs in observations {
        //
        //            let title: String
        //
        //            var type: String = ""
        //
        //            if obs.nest {
        //                type = "Nest "
        //            }
        //            if obs.disturbed {
        //                type.append("Disturbed or Relocated")
        //            }
        //            if obs.hatching {
        //                type.append("Hatching ")
        //            }
        //            if obs.turtle {
        //                type.append("Turtle")
        //            }
        //
        //            title = "\(obs.property) \(type) \(obs.comments)"
        //
        //            alert.addAction(UIAlertAction(title: title, style: .default, handler: { (_) in
        //
        //            }))
        //            }
        //
        //            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        //
        //            present(alert, animated: true)
        //            alert.view.tintColor = UIColor.black
        
    }
    
    @IBAction func noActivityPressed(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "HomeToNoActivity", sender: self)
        
        //        sender.setTitle(data.noActivityValue, for: .normal) NEED TO DO THIS AFTER COMING BACK FROM NoActivityViewController
        
    }
    
    @IBAction func sharePDFPressed(_ sender: UIButton) {
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("tablePdf.pdf")
    let pdfDATA = try? Data.init(contentsOf: path)
    let activitycontroller = UIActivityViewController(activityItems: [pdfDATA], applicationActivities: nil)
                if activitycontroller.responds(to: #selector(getter: activitycontroller.completionWithItemsHandler))
                {
                    activitycontroller.completionWithItemsHandler = {(type, isCompleted, items, error) in
                        if isCompleted
                        {
                        print("completed")
                        }
                }
            }
    activitycontroller.excludedActivityTypes = [UIActivity.ActivityType.airDrop]
                
                self.present(activitycontroller, animated: true, completion: nil)
    }
    
    @IBAction func viewMapButtonPressed(_ sender: Any) {
        
        
        
        self.performSegue(withIdentifier: "ToMap", sender: self)

    }
    
    
    @IBAction func uploadButtonPressed(_ sender: UIButton) {

        
        let alert = UIAlertController(title: "Are you sure you want to upload your data to the database?", message: "This will clear all values", preferredStyle: .alert)
        
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            //Read from Realm
            let observations = self.realm.objects(Observation.self)
            
            
            for obs in observations {
//
//                var upload: Dictionary<String, Any> = [:]
//
//                var type: Array<Any> = []
//
                let images = [obs.image1, obs.image2, obs.image3, obs.image4, obs.image5]
//
//                if obs.turtle {type.append(obs.turtleType)}
//                if obs.existingNestDisturbed {type.append("disturbed")}
//                if obs.nest {type.append(obs.nestType)}
                var hatchingL: Dictionary<String, Bool> = [:]
                if let hatch = obs.hatchingDetails {
                    
                    if hatch.hatchingExists { hatchingL["exists"] = hatch.hatchingExists }
                    if hatch.noProblems { hatchingL["noProblems"] = hatch.noProblems }
                    if hatch.lights { hatchingL["lights"] = hatch.lights }
                    if hatch.trash { hatchingL["trash"] = hatch.trash }
                    if hatch.sewer { hatchingL["sewer"] = hatch.sewer }
                    if hatch.plants { hatchingL["plants"] = hatch.plants }
                    if hatch.other { hatchingL["other"] = hatch.other }
//                    if hatch.numDead { hatchingL["dead"] = hatch.numDead }
//                    if hatch.numStranded { hatchingL["stranded"] = hatch.numStranded }
//                    if hatch.numSuccess{ hatchingL["success"] = hatch.numSuccess }





                }
//
//                upload["date"] = obs.date
//                upload["property"] = obs.property != "" ? obs.property : nil
//                upload["zone"] = obs.zoneLocation != "" ? obs.zoneLocation : nil
//                upload["coords"] = obs.lat != 0 && obs.lon != 0 ? [obs.lat, obs.lon] : nil
//                upload["comments"] = obs.comments != "" ? obs.comments : nil
//                upload["type"] = type != [] ? type : nil
//                upload["userid"] = self.defaults.string(forKey: "userID") ?? ""
//                upload["imageURLS"] = obs.id
                
                let hatchingData = [
                "exists": obs.hatchingDetails?.hatchingExists ?? false ? obs.hatchingDetails?.hatchingExists : nil,
                "noProblems": obs.hatchingDetails?.noProblems ?? false ? obs.hatchingDetails?.noProblems : nil,
                "lights": obs.hatchingDetails?.lights ?? false ? obs.hatchingDetails?.lights : nil,
                "trash": obs.hatchingDetails?.trash ?? false ? obs.hatchingDetails?.trash: nil,
                "sewer": obs.hatchingDetails?.sewer ?? false ? obs.hatchingDetails?.sewer : nil,
                "plants": obs.hatchingDetails?.plants ?? false ? obs.hatchingDetails?.plants : nil,
                "other": obs.hatchingDetails?.other ?? false ? obs.hatchingDetails?.other : nil
                ]
                
                let hatchingDataData = [
                "numSuccess": obs.numSuccess != 0 ? obs.numSuccess : nil,
                "numStranded": obs.numStranded != 0 ? obs.numStranded : nil,
                "numDead": obs.numDead != 0 ? obs.numDead : nil
                ]
                
                let type = [
                    "hatching": obs.hatchingDetails != nil ? hatchingData : nil,
                    "hatchingData": obs.hatchingDetails != nil ? hatchingDataData : nil,
                    "turtle": obs.turtle ? obs.turtleType : nil,
                    "disturbed": obs.existingNestDisturbed ? obs.existingNestDisturbedType : nil,
                    "nest": obs.emerge ? obs.emergeType : nil
                    ] as [String : Any]
                //   NEED TO ADD "NO ACTIVITY" VALUES
                
                self.db.collection("observationsTest").addDocument(data: [
                    "date": obs.date,
                    "id": obs.id,
                    "property": obs.property != "" ? obs.property : nil,
                    "zone": obs.zoneLocation != "" ? obs.zoneLocation : nil,
                    "coords": obs.lat != 0 && obs.lon != 0 ? [obs.lat, obs.lon] : nil,
                    "comments": obs.comments != "" ? obs.comments : nil,
                    "userid": self.defaults.string(forKey: "userID") ?? "",
                    "imageURLS": obs.id,
                    "type": type
                    
                ]) { (error) in
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
                
                
                
                let storageRef = self.storage.reference()
                for image in 0...4 {
                    if images[image] != "" {
                        if var documentsPathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                            //This gives you the URL of the path
                            documentsPathURL.appendPathComponent("\(images[image]).jpg")
                            let imageRef = storageRef.child("\(obs.id)/image\(image).jpg")
                            print("The imageRef is \(imageRef)")
                            
                            print("documentsPathURL \(documentsPathURL)")
                            
                            imageRef.putFile(from: documentsPathURL, metadata: nil)
                        }
                    }
                }
            }
            
            let noActs = self.realm.objects(NoActivityReport.self)
            
            for noAct in noActs {
                self.db.collection("noActivity's").addDocument(data: [
                    "id": noAct.id,
                    "a": noAct.aNoActivity,
                    "b": noAct.bNoActivity,
                    "c": noAct.cNoActivity,
                    "d": noAct.dNoActivity,
                    "e": noAct.eNoActivity,
                    "f": noAct.fNoActivity
                ]) { (error) in
                    if let error = error {
                        print("error saving noAct to FireBase, \(error)")
                    } else {
                        do {
                            try self.realm.write({
                                self.realm.delete(noAct)
                            })
                        } catch {
                            print("error deleting from realm: \(error)")
                        }
                    }
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        present(alert, animated: true)
        alert.view.tintColor = UIColor.black
        
    }
    
}
