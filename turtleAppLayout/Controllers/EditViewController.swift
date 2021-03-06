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
    
    var prevdata = Observation()
    
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
    let datePicker = UIDatePicker()
    
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
    @IBOutlet weak var speciesButton: UIButton!
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        realm.beginWrite()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        try! realm.commitWrite()
    }
    
    func copyObs(to from: Observation, from to: Observation) {
        from.id = to.id
        from.date = to.date
        from.zoneLocation = to.zoneLocation
        from.property = to.property
        from.lat = to.lat
        from.lon = to.lon
        from.accuracy = to.accuracy
        from.emerge = to.emerge
        from.turtle = to.turtle
        from.existingNestDisturbed = to.existingNestDisturbed
        from.emergeType = to.emergeType
        from.turtleType = to.turtleType
        from.species = to.species
        from.existingNestDisturbedType = to.existingNestDisturbedType
        from.hatchingBool = to.hatchingBool
        from.hatchingDetails = to.hatchingDetails
        from.noProblems = to.noProblems
        from.lights = to.lights
        from.trash = to.trash
        from.sewer = to.sewer
        from.plants = to.plants
        from.other = to.other
        from.numSuccess = to.numSuccess
        from.numStranded = to.numStranded
        from.numDead = to.numDead
        from.image1 = to.image1
        from.image2 = to.image2
        from.image3 = to.image3
        from.image4 = to.image4
        from.image5 = to.image5
        from.comments = to.comments
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if data != nil {
            copyObs(to: prevdata, from: data!)
            /*
             prevdata.id = data!.id
             prevdata.date = data!.date
             prevdata.zoneLocation = data!.zoneLocation
             prevdata.property = data!.property
             prevdata.lat = data!.lat
             prevdata.lon = data!.lon
             prevdata.accuracy = data!.accuracy
             prevdata.emerge = data!.emerge
             prevdata.turtle = data!.turtle
             prevdata.existingNestDisturbed = data!.existingNestDisturbed
             prevdata.emergeType = data!.emergeType
             prevdata.turtleType = data!.turtleType
             prevdata.species = data!.species
             prevdata.existingNestDisturbedType = data!.existingNestDisturbedType
             prevdata.hatchingBool = data!.hatchingBool
             prevdata.hatchingDetails = data!.hatchingDetails
             prevdata.noProblems = data!.noProblems
             prevdata.lights = data!.lights
             prevdata.trash = data!.trash
             prevdata.sewer = data!.sewer
             prevdata.plants = data!.plants
             prevdata.other = data!.other
             prevdata.numSuccess = data!.numSuccess
             prevdata.numStranded = data!.numStranded
             prevdata.numDead = data!.numDead
             prevdata.image1 = data!.image1
             prevdata.image2 = data!.image2
             prevdata.image3 = data!.image3
             prevdata.image4 = data!.image4
             prevdata.image5 = data!.image5
             prevdata.comments = data!.comments
             */
            /*
             print(prevdata.zoneLocation)
             title = "Edit \(data!.id)"
             */
            print("Data is not nil!!!")
            
            fillTextFields()
        }
        else {
            //            put an alert here?
            print("No data to load.")
        }
        
        createDatePicker()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        self.commentsTextView.delegate = self
        
    }
    
    func createDatePicker() {
        datePicker.date = data!.date
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(handleDatePicker(sender:)))
        toolbar.setItems([doneBtn], animated: true)
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicker
        
        let datePicker = UIDatePicker()
        
        datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
    }
    
    @objc func handleDatePicker (sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        //        formatter.dateStyle = .medium
        //        formatter.timeStyle = .medium
        //        print(datePicker.date)
        dateFormatter.dateFormat = "d MMM yyyy, HH:mm:ss"
        
        dateTextField.text = dateFormatter.string(from: datePicker.date)
        data!.date = datePicker.date
        self.view.endEditing(true)
    }
    
    func fillTextFields () {
        
        let dateFormatter = DateFormatter()
        //        dateFormatter.locale = Locale(identifier: "fr")
        //        dateFormatter.dateStyle = .medium
        //        dateFormatter.timeStyle = .medium
        dateFormatter.dateFormat = "d MMM yyyy, HH:mm:ss"
        dateTextField.text = dateFormatter.string(from:data!.date)
        
        zoneButton.setTitle(data!.zoneLocation, for: .normal)
        
        if data!.lat != 0.0 && data!.lon != 0.0 {
            let latAsStr = String(format: "%.10f",data!.lat)
            let lonAsStr = String(format: "%.10f",data!.lon)
            let accAsStr = String(format: "%.2f",data!.accuracy)
            accuracyLabel.text = accAsStr
            latitudeTextField.text = latAsStr
            longitudeTextField.text = lonAsStr
            
        } else {
            locationButton.setTitle("--", for: .normal)
        }
        var propertyDesc = ""
        
        if var index = Int(String(data!.property.dropFirst().dropFirst())) {
            index -= 1
            switch data!.property.first {
            case "A":
                propertyDesc = K.propertiesInA[index].1
                
            case "B":
                propertyDesc = K.propertiesInB[index].1
                
            case "C":
                propertyDesc = K.propertiesInC[index].1
                
            case "D":
                propertyDesc = K.propertiesInD[index].1
                
            case "E":
                propertyDesc = K.propertiesInE[index].1
                
            case "F":
                propertyDesc = K.propertiesInF[index].1
                
                //            case "G":
                
            default:
                propertyDesc = "No property/lot selected"
            }
        }
        
        propertyButton.setTitle("\(data!.property): \(propertyDesc)", for: .normal)
        locationButton.setTitle("Retake GPS?", for: .normal)
        emergeButton.setTitle(data!.emerge ? data!.emergeType : "--", for: .normal)
        existingNestDisturbedButton.setTitle(data!.existingNestDisturbed ? data!.existingNestDisturbedType : "--", for: .normal)
        turtleButton.setTitle(data!.turtle ? data!.turtleType : "--", for: .normal)
        
        speciesButton.setTitle(data!.species, for: .normal)
        
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
        print(data)
        
        
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
        case "G":
            propertyList = K.propertiesInG
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
        let alert = UIAlertController(title: "Change GPS coordinates?", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Take new GPS reading now", style: .default, handler: { (_) in
            self.locationManager.requestLocation()
            sender.setTitle("Getting: hold position . . .", for: .normal)
            
        }))
        alert.addAction(UIAlertAction(title: "Clear GPS fields", style: .default, handler: { (_) in
            self.latitudeTextField.text = "0.0"
            self.longitudeTextField.text = "0.0"
            self.accuracyLabel.text = "--"
            self.data!.lat = 0.0
            self.data!.lon = 0.0
            self.data!.accuracy = 0.0
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
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
                self.data!.existingNestDisturbedType = "moved to"
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
    
    @IBAction func speciesButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "UNKNOWN", style: .default, handler: { (action) in
            sender.setTitle("Unknown", for: .normal)
            self.data!.species = ""
        }))
        
        alert.addAction(UIAlertAction(title: "OLIVE RIDLEY", style: .default, handler: { (action) in
            sender.setTitle("Olive Ridley", for: .normal)
            self.data!.species = "olive ridley"
        }))
        alert.addAction(UIAlertAction(title: "GREEN", style: .default, handler: { (action) in
            sender.setTitle("Green", for: .normal)
            self.data!.species = "green"
        }))
        alert.addAction(UIAlertAction(title: "HAWKSBILL", style: .default, handler: { (action) in
            self.data!.species = "hawksbill"
            sender.setTitle("Hawksbill", for: .normal)
            
        }))
        alert.addAction(UIAlertAction(title: "LEATHERBACK", style: .default, handler: { (action) in
            self.data!.species = "leatherback"
            sender.setTitle("Leatherback", for: .normal)
            
        }))
        
        present(alert, animated: true)
        alert.view.tintColor = UIColor.black
        
        
    }
    
    
    @IBAction func hatchingBoolButtonPressed(_ sender: UIButton) {
        if data!.hatchingBool == true {
            
            //            Add an alert here: "Clear all hatching details and set hatching to false?"
            let alert = UIAlertController(title: "Clear all hatching details and set hatching to false?", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                self.data!.hatchingBool = false
                sender.setTitle("No", for: .normal)
                
                self.noProblemsButton.setTitle("", for: .normal)
                self.lightsButton.setTitle("", for: .normal)
                self.trashButton.setTitle("", for: .normal)
                self.sewerButton.setTitle("", for: .normal)
                self.plantsButton.setTitle("", for: .normal)
                self.otherButton.setTitle("", for: .normal)
                self.successButton.setTitle("0", for: .normal)
                self.strandedButton.setTitle("0", for: .normal)
                self.deadButton.setTitle("0", for: .normal)
                
                self.data!.noProblems = false
                self.data!.lights = false
                self.data!.trash = false
                self.data!.sewer = false
                self.data!.plants = false
                self.data!.other = false
                
                self.data!.numSuccess = 0
                self.data!.numStranded = 0
                self.data!.numDead = 0
            }))
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
                
            }))
            
            present(alert, animated: true)
            
        } else {
            data!.hatchingBool = true
            sender.setTitle("Yes", for: .normal)
        }
        
        print("hatching is \(data!.hatchingBool)")
    }
    
    @IBAction func noProblemsButtonPressed(_ sender: UIButton) {
        data!.hatchingBool = true
        hatchingButton.setTitle("Yes", for: .normal)
        
        data!.noProblems = !data!.noProblems
        if data!.noProblems {
            sender.setTitle("✓", for: .normal)
            
            //     Consider whether to make selecting "No Problems" clear all the other problems
            lightsButton.setTitle("", for: .normal)
            trashButton.setTitle("", for: .normal)
            sewerButton.setTitle("", for: .normal)
            plantsButton.setTitle("", for: .normal)
            otherButton.setTitle("", for: .normal)
            
            data!.lights = false
            data!.trash = false
            data!.sewer = false
            data!.plants = false
            data!.other = false
            print("No problems")
        } else {
            sender.setTitle("", for: .normal)
            print("Problems")
        }
    }
    
    @IBAction func lightsButtonPressed(_ sender: UIButton) {
        data!.noProblems = false
        noProblemsButton.setTitle("", for: .normal)
        data!.hatchingBool = true
        hatchingButton.setTitle("Yes", for: .normal)
        
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
        data!.noProblems = false
        noProblemsButton.setTitle("", for: .normal)
        data!.hatchingBool = true
        hatchingButton.setTitle("Yes", for: .normal)
        
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
        data!.noProblems = false
        noProblemsButton.setTitle("", for: .normal)
        data!.hatchingBool = true
        hatchingButton.setTitle("Yes", for: .normal)
        
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
        data!.noProblems = false
        noProblemsButton.setTitle("", for: .normal)
        data!.hatchingBool = true
        hatchingButton.setTitle("Yes", for: .normal)
        
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
        data!.noProblems = false
        noProblemsButton.setTitle("", for: .normal)
        data!.hatchingBool = true
        hatchingButton.setTitle("Yes", for: .normal)
        
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
            
            self.data!.hatchingBool = true
            self.hatchingButton.setTitle("Yes", for: .normal)
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
            
            self.data!.hatchingBool = true
            self.hatchingButton.setTitle("Yes", for: .normal)
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
            
            self.data!.hatchingBool = true
            self.hatchingButton.setTitle("Yes", for: .normal)
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
        alert.addAction(UIAlertAction(title: "Delete Photo", style: .default, handler: { (_) in
            self.data!.image1 = ""
            self.photoImage1.image = UIImage()
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
        alert.addAction(UIAlertAction(title: "Delete Photo", style: .default, handler: { (_) in
            self.data!.image2 = ""
            self.photoImage2.image = UIImage()
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
        alert.addAction(UIAlertAction(title: "Delete Photo", style: .default, handler: { (_) in
            self.data!.image3 = ""
            self.photoImage3.image = UIImage()
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
        alert.addAction(UIAlertAction(title: "Delete Photo", style: .default, handler: { (_) in
            self.data!.image4 = ""
            self.photoImage4.image = UIImage()
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
        alert.addAction(UIAlertAction(title: "Delete Photo", style: .default, handler: { (_) in
            self.data!.image5 = ""
            self.photoImage5.image = UIImage()
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
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        print("Cancel")
        
        let alert = UIAlertController(title: "CANCEL CHANGES?", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (_) in
            
            print(self.data)
            print(self.prevdata)
            
            self.dispatchGroup.enter()
            
            self.copyObs(to: self.data!, from: self.prevdata)
            
            
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
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        print("Done button pressed")
        
        let alert = UIAlertController(title: "SAVE CHANGES?", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (_) in
            
            self.dispatchGroup.enter()
            
            self.data!.comments = self.commentsTextView.text ?? ""
            
            // create id -- do we need to delete first and start over?
            var id = "\(self.data!.zoneLocation)-" != "" ? "\(self.data!.zoneLocation)-": "-"
            
            if self.data!.emerge { id.append(self.data!.emergeType == "nest" ? "N" : "F") }
            if self.data!.existingNestDisturbed { id.append(self.data!.existingNestDisturbedType.split(separator: " ")[0] == "moved" ? "R" : "D") }
            
            
            
            if self.data!.hatchingBool { id.append("H") }
            if self.data!.turtle { id.append("T") }
            if id.count < 3 { id.append("O") }
            
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "-yyyyMMdd-HHmmss-"
            
            //            Date needs to be editable.
            id.append(dateFormatter.string(from: self.data!.date))
            id.append(self.defaults.string(forKey: "userID") ?? "NOUSER")
            self.data!.id = id
            
            //  Delete do and catch statements?
            //            do {
            //                try self.realm.write {
            //                    self.realm.add(self.data)
            //                    self.realm.delete(self.data)
            //                }
            //
            //                self.data = Observation()
            //            } catch {
            //                print("Error saving data, \(error) END")
            //            }
            
            if let newLat = Double(self.latitudeTextField.text!) {
                self.data!.lat = newLat
            }
            
            if let newLon = Double(self.longitudeTextField.text!) {
                self.data!.lon = newLon
            }
            
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
            
            
            self.realm.delete(self.data!)
            
            
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
        if imagePicker.sourceType == .camera {
            try realm.beginWrite()
        }
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
        if imagePicker.sourceType == .camera {
            do {
                try realm.commitWrite()
            } catch {
                print(error)
            }
        }
        
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
}
