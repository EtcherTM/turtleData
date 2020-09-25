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

class EditViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    var data: Observation?
//    var temp = Observation()
//    var temphatchingDetails = Hatching()
//    var tempNoProblems: String?
    
    let realm = try! Realm()
    let db = Firestore.firestore()
    
    let storage = Storage.storage()
    
    let locationManager = CLLocationManager()
    
    let imagePicker = UIImagePickerController()
    
    let defaults = UserDefaults.standard
    
    //Setting user id if doesn't exist, replace with the log + alert
    //    var userID: String = ""  SEBO I THINK WE DON'T WANT THIS?
    
    var image = 0
    let dispatchGroup = DispatchGroup()

    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var zoneButton: UIButton!
    @IBOutlet weak var propertyButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!

    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!

    
    @IBOutlet weak var accuracyLabel: UILabel!
    @IBOutlet weak var emergeButton: UIButton!
    @IBOutlet weak var existingNestDisturbedButton: UIButton!
    @IBOutlet weak var turtleButton: UIButton!
    @IBOutlet weak var hatchingButton: UIButton!
    @IBOutlet weak var commentsTextView: UITextView!
    @IBOutlet weak var photoImage1: UIImageView!
    @IBOutlet weak var photoImage2: UIImageView!
    @IBOutlet weak var photoImage3: UIImageView!
    @IBOutlet weak var photoImage4: UIImageView!
    @IBOutlet weak var photoImage5: UIImageView!
    
    
    @IBOutlet weak var hatchingBoolButton: UIButton!
    @IBOutlet weak var noProblemsButton: UIButton!
    @IBOutlet weak var lightsButton: UIButton!
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var sewerButton: UIButton!
    @IBOutlet weak var plantsButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    @IBOutlet weak var successButton: UIButton!
    @IBOutlet weak var strandedButton: UIButton!
    @IBOutlet weak var deadButton: UIButton!
    
    @IBOutlet weak var doneButtonPressed: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        realm.beginWrite()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        try! realm.commitWrite()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if data != nil {
            title = "Edit \(data!.id)"
            print("Data is not nil!!!")
            fillTextFields()
        }
        else {
            //            put an alert here?
            print("No data to load.")
        }
        
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        self.commentsTextView.delegate = self
     
    }
    
    func fillTextFields () {

        let dateFormatter = DateFormatter()
                   
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        dateTextField.text = dateFormatter.string(from: data!.date)
        
        zoneButton.setTitle(data!.zoneLocation, for: .normal)
            
        if data!.lat != 0.0 && data!.lon != 0.0 {
            let latAsStr = String(format: "%.10f", data!.lat)
            let lonAsStr = String(format: "%.10f", data!.lon)
            let accAsStr = String(format: "%.2f", data!.accuracy)
            accuracyLabel.text = accAsStr
            latitudeTextField.text = latAsStr
            longitudeTextField.text = lonAsStr
            
        } else {
            locationButton.setTitle("--", for: .normal)
            
        }
        emergeButton.setTitle(data!.emerge ? data!.emergeType : "--", for: .normal)
        existingNestDisturbedButton.setTitle(data!.existingNestDisturbed ? data!.existingNestDisturbedType : "--", for: .normal)
        turtleButton.setTitle(data!.turtle ? data?.turtleType : "--", for: .normal)
        
        if data!.hatchingBool {
            hatchingButton.setTitle("Yes", for: .normal)
        } else {
            hatchingButton.setTitle("No", for: .normal)
        }
        
        if data!.noProblems {
            noProblemsButton.setTitle("✓", for: .normal)
        } else {
            noProblemsButton.setTitle("", for: .normal)
        }

        if data!.lights {
            lightsButton.setTitle("✓", for: .normal)
        }  else {
            lightsButton.setTitle("", for: .normal)
        }
        
        if data!.trash {
            trashButton.setTitle("✓", for: .normal)
        } else {
            trashButton.setTitle("", for: .normal)
        }
        
        if data!.sewer {
            sewerButton.setTitle("✓", for: .normal)
        } else {
            sewerButton.setTitle("", for: .normal)
        }
        
        if data!.plants {
            plantsButton.setTitle("✓", for: .normal)
        } else {
            plantsButton.setTitle("", for: .normal)
        }
        
        if data!.other {
            otherButton.setTitle("✓", for: .normal)
        } else {
            otherButton.setTitle("", for: .normal)
        }
        
        successButton.setTitle(String(data!.numSuccess), for: .normal)
        strandedButton.setTitle(String(data!.numStranded), for: .normal)
        deadButton.setTitle(String(data!.numDead), for: .normal)
        
        commentsTextView.text = data!.comments
        
        //      Displaying images:
        
        let images = [data!.image1, data!.image2, data!.image3, data!.image4, data!.image5]
        
        for image in 0...4 {
            if images[image] != "" {
                if var documentsPathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                    
                    documentsPathURL.appendPathComponent("\(images[image]).jpg")
                    
                    
                    print(documentsPathURL)
                    let imageToLoad = UIImage(contentsOfFile: documentsPathURL.path) ?? UIImage()
                    
                    
                    switch image {
                    case 0:
                        photoImage1.image = imageToLoad
                    case 1:
                        photoImage2.image = imageToLoad
                    case 2:
                        photoImage3.image = imageToLoad
                    case 3:
                        photoImage4.image = imageToLoad
                    case 4:
                        photoImage5.image = imageToLoad
                    default:
                        print("Error loading images")
                    }
                    
                    
                }
            }
        }
        
    }
    
    

//MARK:- Data Entry
    


    
    
    @IBAction func zoneButtonPressed(_ sender: UIButton) {
        print("zone")
        print(data!)
        
        
        let alert = UIAlertController(title: "SELECT A ZONE", message: "", preferredStyle: .alert)
        
        for zone in K.zones {
            let action = UIAlertAction(title: zone, style: .default) { (_) in
                if self.data!.zoneLocation != zone {
                    self.data!.property = ""
                    self.propertyButton.setTitle("--", for: .normal)
                }
                sender.setTitle(zone, for: .normal)
                self.data!.zoneLocation = zone
                
            }
            alert.addAction(action)
        }
        
        alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { (_) in
            sender.setTitle("--", for: .normal)
            self.data!.zoneLocation = ""
            self.data!.property = ""
            self.propertyButton.setTitle("--", for: .normal)
        }))
        
        present(alert, animated: true)
        alert.view.tintColor = UIColor.black
        
        
    }
    @IBAction func propertyButtonPressed(_ sender: UIButton) {
        print("property")
        
        var propertyList: Array<(String, String)>?
        switch data!.zoneLocation {
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
            let alert = UIAlertController(title: "SELECT A PROPERTY FROM ZONE \(data!.zoneLocation)", message: "", preferredStyle: .alert)
            
            for property in propertyList {
                alert.addAction(UIAlertAction(title: "\(property.0) : \(property.1)", style: .default, handler: { (_) in
                    self.data!.property = property.0
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
        print("location")
        let alert = UIAlertController(title: "Get new GPS coordinates now?", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
            self.locationManager.requestLocation()
                sender.setTitle("Getting: hold position . . .", for: .normal)

            }))
        
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

            present(alert, animated: true)


    }
    
    @IBAction func emergeButtonPressed(_ sender: UIButton) {
        print("emergeButton pressed")
            if !data!.emerge {
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "NEW/PROBABLE NEST", style: .default, handler: { (action) in
                    self.data!.emergeType = "nest"
                    sender.setTitle(self.data!.emergeType, for: .normal)

                }))
                alert.addAction(UIAlertAction(title: "FALSE NEST", style: .default, handler: { (action) in
                    self.data!.emergeType = "false nest"
                    sender.setTitle(self.data!.emergeType, for: .normal)
                }))
                alert.addAction(UIAlertAction(title: "FALSE CRAWL", style: .default, handler: { (action) in
                    self.data!.emergeType = "false crawl"
                    sender.setTitle(self.data!.emergeType, for: .normal)
                    
                }))
        
                
                present(alert, animated: true)
                
            } else {
                sender.setTitle("--", for: .normal)
                data!.emergeType = ""
            }
            
            
            data!.emerge = !data!.emerge
            
    }
    
    @IBAction func existingNestDisturbedButtonPressed(_ sender: UIButton) {
        print("existing nest pressed")
        if !data!.existingNestDisturbed {
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "DISTURBED: NATURAL CAUSE", style: .default, handler: { (action) in
                
                self.data!.existingNestDisturbedType = "disturbed nature"
                sender.setTitle(self.data!.existingNestDisturbedType, for: .normal)
                
            }))
            
            alert.addAction(UIAlertAction(title: "DISTURBED: HUMAN CAUSE", style: .default, handler: { (action) in
                
                self.data!.existingNestDisturbedType = "disturbed human"
                sender.setTitle(self.data!.existingNestDisturbedType, for: .normal)
                
            }))

            alert.addAction(UIAlertAction(title: "LOST: NATURAL CAUSE", style: .default, handler: { (action) in
                self.data!.existingNestDisturbedType = "lost nature"
                sender.setTitle(self.data!.existingNestDisturbedType, for: .normal)
                
            }))
            
            alert.addAction(UIAlertAction(title: "LOST: HUMAN CAUSE", style: .default, handler: { (action) in
                self.data!.existingNestDisturbedType = "lost human"
                sender.setTitle(self.data!.existingNestDisturbedType, for: .normal)
                print("existingNestDisturbedType = \(self.data!.existingNestDisturbedType)")
                
            }))
            
            alert.addAction(UIAlertAction(title: "MOVED FROM: NATURAL CAUSE", style: .default, handler: { (action) in
                self.data!.existingNestDisturbedType = "moved from/ nature"
                sender.setTitle(self.data!.existingNestDisturbedType, for: .normal)
                
            }))
            
            alert.addAction(UIAlertAction(title: "MOVED FROM: HUMAN ACTIVITY", style: .default, handler: { (action) in
                self.data!.existingNestDisturbedType = "moved from/ human"
                sender.setTitle(self.data!.existingNestDisturbedType, for: .normal)
                
            }))
            
            alert.addAction(UIAlertAction(title: "MOVED TO", style: .default, handler: { (action) in
                self.data!.existingNestDisturbedType = "relocated to"
                sender.setTitle(self.data!.existingNestDisturbedType, for: .normal)
                
            }))
            
            present(alert, animated: true)
            
        } else {
            sender.setTitle("--", for: .normal)
            data!.existingNestDisturbedType = ""
        }
        
        data!.existingNestDisturbed = !data!.existingNestDisturbed
        
        
    }
    
    @IBAction func turtleButtonPressed(_ sender: UIButton) {
        print("turtle")
        
        if !data!.turtle {

            let alert = UIAlertController(title: "ADULT TURTLE:", message: "", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "DEAD", style: .default, handler: { (action) in
                self.data!.turtleType = "dead"
                sender.setTitle("dead", for: .normal)
            }))
            alert.addAction(UIAlertAction(title: "ALIVE", style: .default, handler: { (action) in
                self.data!.turtleType = "live"
                sender.setTitle("alive", for: .normal)
            }))
            
            present(alert, animated: true)
            alert.view.tintColor = UIColor.black
            
        } else {
            sender.setTitle("--", for: .normal)
            data!.turtleType = ""
        }
        data!.turtle = !data!.turtle
        
        
    }
    
    @IBAction func hatchingBoolButtonPressed(_ sender: UIButton) {
        if data!.hatchingBool == true {
            
//            Add an alert here: "Clear all hatching details and set hatching to false?"
            
            data!.hatchingBool = true
            sender.setTitle("Yes", for: .normal)
        } else {
            data!.hatchingBool = false
            sender.setTitle("No", for: .normal)
        }
        
        print("hatching is \(data!.hatchingBool)")
    }
    
    @IBAction func noProblemsButtonPressed(_ sender: UIButton) {
        data!.noProblems = !data!.noProblems
        if data!.noProblems {
            sender.setTitle("✓", for: .normal)
            
//     Consider whether to make selecting "No Problems" clear all the other problems
//            lightsButton.setTitle("Lights", for: .normal)
//            trashButton.setTitle("Trash", for: .normal)
//            sewerButton.setTitle("Sewer", for: .normal)
//            plantsButton.setTitle("Plants", for: .normal)
//            otherButton.setTitle("Other", for: .normal)
            print("No problems")
        } else {
            sender.setTitle("", for: .normal)
            print("Problems")
        }
    }
    
    @IBAction func lightsButtonPressed(_ sender: UIButton) {
           data!.lights = !data!.lights
            if data!.lights {
                sender.setTitle("✓", for: .normal)
                print("Lights a problem")
            } else {
                sender.setTitle("", for: .normal)
                print("Lights not a problem")
            }
    }
    
    @IBAction func trashButtonPressed(_ sender: UIButton) {
        data!.trash = !data!.trash
         if data!.trash {
             sender.setTitle("✓", for: .normal)
             print("Trash a problem")
         } else {
             sender.setTitle("", for: .normal)
             print("Trash not a problem")
         }
    }
    
    @IBAction func sewerButtonPressed(_ sender: UIButton) {
        data!.sewer = !data!.sewer
         if data!.sewer {
             sender.setTitle("✓", for: .normal)
             print("Sewer a problem")
         } else {
             sender.setTitle("", for: .normal)
             print("Sewer not a problem")
         }
    }
    
    @IBAction func plantsButtonPressed(_ sender: UIButton) {
        data!.plants = !data!.plants
         if data!.plants {
             sender.setTitle("✓", for: .normal)
             print("Plants a problem")
         } else {
             sender.setTitle("", for: .normal)
             print("Plants not a problem")
         }
    }
    
    @IBAction func otherButtonPressed(_ sender: UIButton) {
        data!.other = !data!.other
         if data!.other {
             sender.setTitle("✓", for: .normal)
             print("Other problem")
         } else {
             sender.setTitle("", for: .normal)
             print("No other problem")
         }
    }
    
    @IBAction func successButtonPressed(_ sender: UIButton) {
        var myTextField : UITextField?
        let alert = UIAlertController.init(title: "Estimate the number of babies that went unassisted to ocean", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            // make sure your outside any property should be accessed with self here
            myTextField = textField
            //Important step assign textfield delegate to self
            myTextField?.delegate = self
            myTextField?.placeholder = "0"
            myTextField?.keyboardType = .numberPad
        }
            
         alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { (_) in
         }))
    
         alert.addAction(UIAlertAction(title: "DONE", style: .default, handler: { (action) in
             guard let num = Int(myTextField!.text!) else { return }
            self.data!.numSuccess = num
             sender.setTitle("\(num)", for: .normal)
         }))

         present(alert, animated: true, completion:nil)
    }
    
    @IBAction func strandedButtonPressed(_ sender: UIButton) {
             var myTextField : UITextField?
             let alert = UIAlertController.init(title: "Enter number of babies that were stranded and needed rescue", message: nil, preferredStyle: .alert)
             alert.addTextField { (textField) in
                 myTextField = textField
                 myTextField?.delegate = self
                 myTextField?.placeholder = "0"
                 myTextField?.keyboardType = .numberPad
             }
             
             alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { (_) in
             }))
        
             alert.addAction(UIAlertAction(title: "DONE", style: .default, handler: { (action) in
                 guard let num = Int(myTextField!.text!) else { return }
                self.data!.numStranded = num
                 sender.setTitle("\(num)", for: .normal)
             }))

            present(alert, animated: true, completion:nil)
    }
    
    @IBAction func deadButtonPressed(_ sender: UIButton) {
        var myTextField : UITextField?
        let alert = UIAlertController.init(title: "Enter number of dead babies found", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            myTextField = textField
            myTextField?.delegate = self
            myTextField?.placeholder = "0"
            myTextField?.keyboardType = .numberPad
        }
        
        alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { (_) in
 
        }))

        alert.addAction(UIAlertAction(title: "DONE", style: .default, handler: { (action) in
            guard let num = Int(myTextField!.text!) else { return }
            self.data!.numDead = num
            sender.setTitle("\(num)", for: .normal)
        }))

        present(alert, animated: true, completion:nil)
        
    }
    @IBAction func photo1ButtonPressed(_ sender: UIButton) {
        print("click1")
        image = 1

//        switch sender.currentTitle ?? "" {
//        case "photo1":
//            image = 1
//        case "photo2":
//            image = 2
//        case "photo3":
//            image = 3
//        case "photo4":
//            image = 4
//        case "photo5":
//            image = 5
//        default:
//            print("DODODODODO")
//        }
        
        let alert = UIAlertController(title: "Choose image source", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (_) in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        print("present Choie")
        present(alert, animated: true)

        
    }
    
    @IBAction func handleGesture1(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
            case .began:

                UIView.animate(withDuration: 0.05,
                               animations: {
                                 self.photoImage1.transform = CGAffineTransform(scaleX: 8.0, y: 8.0)

                },
                               completion: nil)
            case .ended:
                UIView.animate(withDuration: 0.05) {
                    self.photoImage1.transform = CGAffineTransform.identity
                }
            default: break
            }
    }
    
    @IBAction func photo2ButtonPressed(_ sender: UIButton) {
        
        print("click1")
        image = 2
                
        let alert = UIAlertController(title: "Choose image source", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (_) in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        print("present Choie")
        present(alert, animated: true)

    }
    
    @IBAction func handleGesture2(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
             case .began:

                 UIView.animate(withDuration: 0.05,
                                animations: {
                                  self.photoImage2.transform = CGAffineTransform(scaleX: 8.0, y: 8.0)

                 },
                                completion: nil)
             case .ended:
                 UIView.animate(withDuration: 0.05) {
                     self.photoImage2.transform = CGAffineTransform.identity
                 }
             default: break
             }
    }
  
    @IBAction func photo3ButtonPressed(_ sender: UIButton) {
        print("click1")
        image = 3
                
        let alert = UIAlertController(title: "Choose image source", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (_) in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        print("present Choie")
        present(alert, animated: true)

    }
    
    @IBAction func handleGesture3(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
             case .began:

                 UIView.animate(withDuration: 0.05,
                                animations: {
                                  self.photoImage3.transform = CGAffineTransform(scaleX: 8.0, y: 8.0)

                 },
                                completion: nil)
             case .ended:
                 UIView.animate(withDuration: 0.05) {
                     self.photoImage3.transform = CGAffineTransform.identity
                 }
             default: break
             }
    }

    @IBAction func photo4ButtonPressed(_ sender: UIButton) {
         print("click1")
         image = 4
                 
         let alert = UIAlertController(title: "Choose image source", message: "", preferredStyle: .alert)
         
         alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
             self.imagePicker.allowsEditing = false
             self.imagePicker.sourceType = .camera
             self.present(self.imagePicker, animated: true, completion: nil)
         }))
         
         alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (_) in
             self.imagePicker.allowsEditing = false
             self.imagePicker.sourceType = .photoLibrary
             self.present(self.imagePicker, animated: true, completion: nil)
         }))
         print("present Choie")
         present(alert, animated: true)
    }
    
    @IBAction func handleGesture4(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
             case .began:

                 UIView.animate(withDuration: 0.05,
                                animations: {
                                  self.photoImage4.transform = CGAffineTransform(scaleX: 8.0, y: 8.0)

                 },
                                completion: nil)
             case .ended:
                 UIView.animate(withDuration: 0.05) {
                     self.photoImage4.transform = CGAffineTransform.identity
                 }
             default: break
             }
    }
    
    @IBAction func photo5ButtonPressed(_ sender: UIButton) {
        print("click1")
        image = 5
                
        let alert = UIAlertController(title: "Choose image source", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (_) in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        print("present Choie")
        present(alert, animated: true)
        
    }
    
    @IBAction func handleGesture5(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
             case .began:

                 UIView.animate(withDuration: 0.05,
                                animations: {
                                  self.photoImage5.transform = CGAffineTransform(scaleX: 8.0, y: 8.0)

                 },
                                completion: nil)
             case .ended:
                 UIView.animate(withDuration: 0.05) {
                     self.photoImage5.transform = CGAffineTransform.identity
                 }
             default: break
             }
    }
    
 
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        print("Done button pressed")
        
        let alert = UIAlertController(title: "SAVE CHANGES?", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (_) in
            
            self.dispatchGroup.enter()
//            self.data!.date = self.dateTextField.text ?? ""  //Need to turn this into Date format
            self.data!.comments = self.commentsTextView.text ?? ""
            
            // create id -- do we need to delete first and start over?
            var id = "\(self.data!.zoneLocation)-" != "" ? "\(self.data!.zoneLocation)-": "-"
            
            if self.data!.emerge { id.append(self.data!.emergeType == "nest" ? "N" : "F") }
            if self.data!.existingNestDisturbed { id.append(self.data!.existingNestDisturbedType == "disturbed" ? "D" : "R") }

            if self.data!.noProblems || self.data!.lights || self.data!.trash || self.data!.sewer || self.data!.plants || self.data!.other || self.data!.numSuccess != 0 || self.data!.numStranded != 0 || self.data!.numDead != 0 {
                    
                self.data!.hatchingBool = true
                
                } else {
                    self.data!.hatchingBool = false
                }
            
            id.append(self.data!.hatchingBool ? "H" : "")

            id.append(self.data!.turtle ? "T" : "")
            
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "-yyyyMMdd-HHmmss-"
            
//            Need to keep the date the same?  Date needs to be editable.
            id.append(dateFormatter.string(from: Date()))
            id.append(self.defaults.string(forKey: "userID") ?? "NOUSER")
            self.data!.id = id
            
//  Delete do and catch statements?
//            do {
//                try self.realm.write {
//                    self.realm.add(self.data!)
//                    self.realm.delete(self.data!)
//                }
//
//                self.data = Observation()
//            } catch {
//                print("Error saving data, \(error) END")
//            }
            
            self.dispatchGroup.leave()
            print("juoiu)")
            
            self.dispatchGroup.wait()
            
            DispatchQueue.main.async {
            
                self.navigationController?.popViewController(animated: true)

            }
            
        })) // Ends closure begun in line 392
        alert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: nil))
        
        present(alert, animated: true)
       
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        print("Deleting observation")
        
        let alert = UIAlertController(title: "DELETE THIS OBSERVATION?", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
            
            self.dispatchGroup.enter()
            
//            Can the write block be removed?
            do {
                try self.realm.write{
                    self.realm.delete(self.data!)
                }
            } catch {
                print("Eror deleting observation: \(error)")
            }
            
            
            self.dispatchGroup.leave()
            print("Done deleting data")
            
            self.dispatchGroup.wait()
            
            DispatchQueue.main.async {
                print("About to pop vc.")
                self.navigationController?.popViewController(animated: true)

            }
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        present(alert, animated: true)
        
    }
}


//MARK:- Location Extension

extension EditViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("Done getting location.")
            data!.lat = location.coordinate.latitude
            data!.lon = location.coordinate.longitude
            data!.accuracy = location.horizontalAccuracy
            let latAsStr = String(format: "%.10f", data!.lat)
            let lonAsStr = String(format: "%.10f", data!.lon)
            let accAsStr = String(format: "%.2f", location.horizontalAccuracy)
            latitudeTextField.text = latAsStr
            longitudeTextField.text = lonAsStr
            accuracyLabel.text = accAsStr
            locationButton.setTitle("Retake GPS?", for: .normal)
        }
        
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

//MARK:- Photo taker thing

extension EditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageTaken = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            //          Call function to set the image on the obs screen
            //          Call function to generate reference
            //           Maybe instead of saving to realm here just save image to variables imageTaken1 - imageTaken5 and save to realm with the rest of data
            //     Also note after 5 photos they can just replace a photo by tapping on it.
            
            
            
            
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
            
            switch image {
            case 1:
                photoImage1.image = imageTaken
                data!.image1 = imgRef
            case 2:
                photoImage2.image = imageTaken
                data!.image2 = imgRef
            case 3:
                photoImage3.image = imageTaken
                data!.image3 = imgRef
            case 4:
                photoImage4.image = imageTaken
                data!.image4 = imgRef
            case 5:
                photoImage5.image = imageTaken
                data!.image5 = imgRef
            default:
                print("error BOUBOUBOBUOBUBOUBOBUOUBBUBUBO")
            }
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
}
