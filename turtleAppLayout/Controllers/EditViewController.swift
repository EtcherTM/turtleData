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


    @IBOutlet weak var zoneButton: UIButton!
    @IBOutlet weak var propertyButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var accuracyLabel: UILabel!
    @IBOutlet weak var nestButton: UIButton!
    @IBOutlet weak var disturbedButton: UIButton!
    @IBOutlet weak var turtleButton: UIButton!
    @IBOutlet weak var hatchingButton: UIButton!
    @IBOutlet weak var commentsTextView: UITextField!
    @IBOutlet weak var photoImageView1: UIImageView!
    @IBOutlet weak var photoImageView2: UIImageView!
    @IBOutlet weak var photoImageView3: UIImageView!
    @IBOutlet weak var photoImageView4: UIImageView!
    @IBOutlet weak var photoImageView5: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.delegate = self
//        imagePicker.delegate = self
//        imagePicker.allowsEditing = false
//        imagePicker.sourceType = .camera
//        self.commentsTextView.delegate = self
//
//        //Set image ids
//        photoImage1.tag = 1
//        photoImage2.tag = 2
//        photoImage3.tag = 3
//        photoImage4.tag = 4
//        photoImage5.tag = 5
//
//        print(photoImage1.tag)
//        print(photoImage1)
//        print(photoImage2.tag)
//        print(photoImage2)
//        print(photoImage3.tag)
//        print(photoImage4.tag)
//        print(photoImage5.tag)
//



    }

    @IBAction func zoneButtonPressed(_ sender: UIButton) {
    }
    @IBAction func propertyButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func nestButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func disturbedButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func turtleButtonPressed(_ sender: UIButton) {
    }

    @IBAction func hatchingButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func photo1ButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func photo2ButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func photo3ButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func photo4ButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func photo5ButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
    }
}
