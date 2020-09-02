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

class HomeViewController: UIViewController {

    let realm = try! Realm()
    let defaults = UserDefaults.standard
    let db = Firestore.firestore()
    let storage = Storage.storage()

//    var userIdentification: String? = nil  ** NEED HELP! **
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userIDTextField.text = defaults.value(forKey: "userID") ?? nil
        //        let userIdentification = defaults.string(forKey: "userID") ** NEED HELP! **

        // Do any additional setup after loading the view.
    }

    
    @IBAction func userIDTextField(_ sender: UITextField) {
        print("entering user id")
        print(sender.text)
//        let userIdentification = sender.text ?? nil  ** NEED HELP **
        
        defaults.set(sender.text ?? nil, forKey: "userID")
        print(defaults.value(forKey: "userID"))
        // userID should be saved in user defaults
        
    }
    @IBAction func newObsButtonPressed(_ sender: UIButton) {
        print(defaults.value(forKey: "userID"))
//        if defaults.value(forKey: "userID") == nil {
            print("Enter a User ID first")

//        }
    }

//        If userID is nil or "" then show alert saying add user ID first
        
    
    
    
    @IBAction func uploadButtonPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Are you sure you want to upload your data to the database?", message: "This will clear all values", preferredStyle: .alert)
        
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            //Read from Realm
            let observations = self.realm.objects(Observation.self)
            
            
            for obs in observations {
                
                var upload: Dictionary<String, Any> = [:]
                
                var type = [String]()
                
                let images = [obs.image1, obs.image2, obs.image3, obs.image4, obs.image5]
                
                if obs.turtle {type.append(obs.turtleType)}
                if obs.disturbed {type.append("disturbed")}
                if obs.nest {type.append(obs.nestType)}
                if obs.hatching {type.append(obs.hatchingType)}
                
                upload["date"] = obs.date
                upload["property"] = obs.property != "" ? obs.property : nil
                upload["zone"] = obs.zoneLocation != "" ? obs.zoneLocation : nil
                upload["coords"] = obs.lat != 0 && obs.lon != 0 ? [obs.lat, obs.lon] : nil
                upload["comments"] = obs.comments != "" ? obs.comments : nil
                upload["type"] = type != [] ? type : nil
                upload["userid"] = self.defaults.string(forKey: "userID") ?? ""
                upload["imageURLS"] = obs.id
                
                
                self.db.collection("observations").addDocument(data: upload) { (error) in
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
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
}
