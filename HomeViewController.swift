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
    
    
    
    //    @IBAction func sharePDFPressed(_ sender: UIButton) {
    //        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("tablePdf.pdf")
    //        let pdfDATA = try? Data.init(contentsOf: path)
    //        let activitycontroller = UIActivityViewController(activityItems: [pdfDATA], applicationActivities: nil)
    //        if activitycontroller.responds(to: #selector(getter: activitycontroller.completionWithItemsHandler))
    //        {
    //            activitycontroller.completionWithItemsHandler = {(type, isCompleted, items, error) in
    //                if isCompleted
    //                {
    //                    print("completed")
    //                }
    //            }
    //        }
    //        activitycontroller.excludedActivityTypes = [UIActivity.ActivityType.airDrop]
    //
    //        self.present(activitycontroller, animated: true, completion: nil)
    //    }
    //
    @IBAction func viewMapButtonPressed(_ sender: Any) {
        
        
        
        self.performSegue(withIdentifier: "ToMap", sender: self)
        
    }
    
    
    @IBAction func uploadButtonPressed(_ sender: UIButton) {
        
        //if empty, say so
        let alert = UIAlertController(title: "Did you share a PDF of your list first? Uploading your data to the database erases it locally.", message: nil, preferredStyle: .alert)
        
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            //Read from Realm
            
            let observations = self.realm.objects(Observation.self)
            
            for obs in observations {
                
           
                let images = [obs.image1, obs.image2, obs.image3, obs.image4, obs.image5]
        
                var data = [
                "date": obs.date,
                "id": obs.id,
                "coords":  GeoPoint(latitude: obs.lat, longitude: obs.lon),
                "userid": self.defaults.string(forKey: "userID") ?? "",
                "imageURLS": obs.id,
                "species": obs.species == "" ? "olive ridley" : obs.species,
                "active": true
                
                ] as [String : Any]
                
                var type: Array<String> = []
                
                if obs.turtle { type.append(obs.turtleType) }
                if obs.existingNestDisturbed { type.append(obs.existingNestDisturbedType) }
                if obs.emerge { type.append(obs.emergeType) }
                
                var hatchingDetails: Array<Any> = []
                
                    if obs.hatchingBool {
                        type.append("hatching")
                        if obs.noProblems { hatchingDetails.append("no problems") }
                        if obs.lights { hatchingDetails.append("lights") }
                        if obs.trash { hatchingDetails.append("trash") }
                        if obs.sewer { hatchingDetails.append("sewer") }
                        if obs.plants { hatchingDetails.append("plants") }
                        if obs.other { hatchingDetails.append("other") }
                        
                        data["hatchingDetails"] = [
                            obs.numSuccess,
                            obs.numDead,
                            obs.numStranded
                        ]
                    }
                
                    
                    
                    
                    if obs.zoneLocation != "" { data["zone"] = obs.zoneLocation }
                    if obs.property != "" { data["property"] = obs.property }
                    if obs.comments != "" { data["comments"] = obs.comments }
                    data["type"] = type
                    data["hatchingType"] = hatchingDetails
                    print(data)
                    self.db.collection("observations").document("\(obs.id)").setData(data) { (error) in
                        if let error = error {
                            print("Error saving to Firebase, \(error)")
                        } else {
                            //Destroy Realm safely, only if successfully created to FireBase? MAYBE? Yes.
                            do {
                                try self.realm.write {
                                    self.realm.delete(obs)
                                    print("eeee")
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
                
            
            self.done()
            
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        present(alert, animated: true)
        alert.view.tintColor = UIColor.black
        
    }
    
    func done() {
        let listOfObservations = try! Realm().objects(Observation.self)
        if listOfObservations.count == 0 {
            let done = UIAlertController(title: "Done!", message: "", preferredStyle: .alert)
            done.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(done, animated: true)
        }
        print("D")
    }
}
