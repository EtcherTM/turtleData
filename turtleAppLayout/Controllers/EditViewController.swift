//
//  EditViewController.swift
//  turtleAppLayout
//
//  Created by Olivia James on 9/9/20.
//  Copyright © 2020 Sebastien James. All rights reserved.
//

import UIKit
import CoreLocation
import RealmSwift
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage

class EditViewController: UIViewController, UITextViewDelegate {

    var data: Observation?
    
    let realm = try! Realm()
    let db = Firestore.firestore()
    
    let storage = Storage.storage()
    
    let locationManager = CLLocationManager()
    
    let imagePicker = UIImagePickerController()
    
    let defaults = UserDefaults.standard

//    var userID: String = ""





}
