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
    
    var temp = Observation()
    
    
    
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

    
    @IBOutlet weak var zoneButton: UIButton!
    @IBOutlet weak var propertyButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var emergeButton: UIButton!
    @IBOutlet weak var existingNestDisturbedButton: UIButton!
    @IBOutlet weak var turtleButton: UIButton!
    @IBOutlet weak var hatchingButton: UIButton!
    @IBOutlet weak var commentsTextView: UITextView!
    @IBOutlet weak var photoImageView1: UIImageView!
    @IBOutlet weak var photoImageView2: UIImageView!
    @IBOutlet weak var photoImageView3: UIImageView!
    @IBOutlet weak var photoImageView4: UIImageView!
    @IBOutlet weak var photoImageView5: UIImageView!
    
    @IBOutlet weak var doneButtonPressed: UIButton!
    
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
    
    func fillTextFields () {
        temp.id = data!.id
        temp.date = data!.date
        
        temp.zoneLocation = data!.zoneLocation
        temp.property = data!.property
        
        temp.lat = data!.lat
        temp.lon = data!.lon
        
        temp.emerge = data!.emerge
        temp.turtle = data!.turtle
        temp.existingNestDisturbed = data!.existingNestDisturbed
        
        temp.emergeType = data!.emergeType
        temp.turtleType = data!.turtleType
        temp.existingNestDisturbedType = data!.existingNestDisturbedType
        
        temp.hatchingDetails = data!.hatchingDetails
        
        temp.image1 = data!.image1
        temp.image2 = data!.image2
        temp.image3 = data!.image3
        temp.image4 = data!.image4
        temp.image5 = data!.image5
        
        temp.comments = data!.comments
        
        zoneButton.setTitle(data!.zoneLocation, for: .normal)
        
        
        var propertyDesc = ""
        
        if var index = Int(String(data!.property.dropFirst().dropFirst())) {
            index -= 1
            switch data?.property.first {
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
            default:
                propertyDesc = "No property/lot selected"
            }
        }
        propertyButton.setTitle(propertyDesc, for: .normal)
        
        
        if data!.lat != 0.0 && data!.lon != 0.0 {
            let latAsStr = String(format: "%.2f", data!.lat)
            let lonAsStr = String(format: "%.2f", data!.lon)
            let accAsStr = String(format: "%.1f", data!.accuracy)
            locationButton.setTitle("\(latAsStr), \(lonAsStr) ± \(accAsStr) m", for: .normal)
        } else {
            locationButton.setTitle("--", for: .normal)
            
        }
        emergeButton.setTitle(temp.emerge ? temp.emergeType : "--", for: .normal)
        existingNestDisturbedButton.setTitle(temp.existingNestDisturbed ? temp.existingNestDisturbedType : "--", for: .normal)
        turtleButton.setTitle(data!.turtle ? data?.turtleType : "--", for: .normal)
                hatchingButton.setTitle("Edit Hatching Data", for: .normal)
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
                        photoImageView1.image = imageToLoad
                    case 1:
                        photoImageView2.image = imageToLoad
                    case 2:
                        photoImageView3.image = imageToLoad
                    case 3:
                        photoImageView4.image = imageToLoad
                    case 4:
                        photoImageView5.image = imageToLoad
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
        print(temp)
        
        
        let alert = UIAlertController(title: "SELECT A ZONE", message: "", preferredStyle: .alert)
        
        for zone in K.zones {
            let action = UIAlertAction(title: zone, style: .default) { (_) in
                if self.temp.zoneLocation != zone {
                    self.temp.property = ""
                    self.propertyButton.setTitle("--", for: .normal)
                }
                sender.setTitle(zone, for: .normal)
                self.temp.zoneLocation = zone
                
            }
            alert.addAction(action)
        }
        
        alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { (_) in
            sender.setTitle("--", for: .normal)
            self.temp.zoneLocation = ""
            self.temp.property = ""
            self.propertyButton.setTitle("--", for: .normal)
        }))
        
        present(alert, animated: true)
        alert.view.tintColor = UIColor.black
        
        
    }
    @IBAction func propertyButtonPressed(_ sender: UIButton) {
        print("property")
        
        var propertyList: Array<(String, String)>?
        switch temp.zoneLocation {
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
            let alert = UIAlertController(title: "SELECT A PROPERTY FROM ZONE \(temp.zoneLocation)", message: "", preferredStyle: .alert)
            
            for property in propertyList {
                alert.addAction(UIAlertAction(title: "\(property.0) : \(property.1)", style: .default, handler: { (_) in
                    self.temp.property = property.0
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
        
        locationManager.requestLocation()
        sender.setTitle("Getting: hold position . . .", for: .normal)
    }
    
    @IBAction func emergeButtonPressed(_ sender: UIButton) {
        print("emergeButton pressed")
            if !temp.emerge {
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "NEW/PROBABLE NEST", style: .default, handler: { (action) in
                    self.temp.emergeType = "nest"
                    sender.setTitle(self.temp.emergeType, for: .normal)

                }))
                alert.addAction(UIAlertAction(title: "FALSE NEST", style: .default, handler: { (action) in
                    self.temp.emergeType = "false nest"
                    sender.setTitle(self.temp.emergeType, for: .normal)
                }))
                alert.addAction(UIAlertAction(title: "FALSE CRAWL", style: .default, handler: { (action) in
                    self.temp.emergeType = "false crawl"
                    sender.setTitle(self.temp.emergeType, for: .normal)
                    
                }))
        
                
                present(alert, animated: true)
                
            } else {
                sender.setTitle("--", for: .normal)
                temp.emergeType = ""
            }
            
            
            temp.emerge = !temp.emerge
            
    }
    
    @IBAction func existingNestDisturbedButtonPressed(_ sender: UIButton) {
        print("existing nest pressed")
        if !temp.existingNestDisturbed {
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "DISTURBED BY NATURAL CAUSE", style: .default, handler: { (action) in
                
                self.temp.existingNestDisturbedType = "disturbed nature"
                sender.setTitle(self.temp.existingNestDisturbedType, for: .normal)
                
            }))
            
            alert.addAction(UIAlertAction(title: "DISTURBED BY HUMAN CAUSE", style: .default, handler: { (action) in
                
                self.temp.existingNestDisturbedType = "disturbed human"
                sender.setTitle(self.temp.existingNestDisturbedType, for: .normal)
                
            }))

            alert.addAction(UIAlertAction(title: "LOST BY NATURAL CAUSE", style: .default, handler: { (action) in
                self.temp.existingNestDisturbedType = "lost nature"
                sender.setTitle(self.temp.existingNestDisturbedType, for: .normal)
                
            }))
            
            alert.addAction(UIAlertAction(title: "LOST BY HUMAN CAUSE", style: .default, handler: { (action) in
                self.temp.existingNestDisturbedType = "lost human"
                sender.setTitle(self.temp.existingNestDisturbedType, for: .normal)
                print("existingNestDisturbedType = \(self.temp.existingNestDisturbedType)")
                
            }))
            
            alert.addAction(UIAlertAction(title: "MOVED FROM: NATURAL CAUSE", style: .default, handler: { (action) in
                self.temp.existingNestDisturbedType = "relocated nature"
                sender.setTitle(self.temp.existingNestDisturbedType, for: .normal)
                
            }))
            
            alert.addAction(UIAlertAction(title: "MOVED FROM: HUMAN ACTIVITY", style: .default, handler: { (action) in
                self.temp.existingNestDisturbedType = "relocated nature"
                sender.setTitle(self.temp.existingNestDisturbedType, for: .normal)
                
            }))
            
            alert.addAction(UIAlertAction(title: "MOVED TO", style: .default, handler: { (action) in
                self.temp.existingNestDisturbedType = "relocated to"
                sender.setTitle(self.temp.existingNestDisturbedType, for: .normal)
                
            }))
            
            present(alert, animated: true)
            
        } else {
            sender.setTitle("--", for: .normal)
            temp.existingNestDisturbedType = ""
        }
        
        temp.existingNestDisturbed = !temp.existingNestDisturbed
        
        
    }
    
    @IBAction func turtleButtonPressed(_ sender: UIButton) {
        print("turtle")
        
    }
    
    @IBAction func hatchingButtonPressed(_ sender: UIButton) {
        print("hatching")
        
//        performSegue(withIdentifier: "EditToHatching", sender: self)
        
    }
    
    @IBAction func photoButtonPressed(_ sender: UIButton) {
        print("click1")
        
        switch sender.currentTitle ?? "" {
        case "photo1":
            image = 1
        case "photo2":
            image = 2
        case "photo3":
            image = 3
        case "photo4":
            image = 4
        case "photo5":
            image = 5
        default:
            print("DODODODODO")
        }
        
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
        
        
        //need to wait until other one is dismissed
        
    }
    
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        print("Done button pressed")
        
        let alert = UIAlertController(title: "SAVE THIS OBSERVATION AND CLEAR ALL FIELDS?", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (_) in
            
            self.dispatchGroup.enter()
            
            self.temp.comments = self.commentsTextView.text ?? ""
            
            // create id
            var id = "\(self.temp.zoneLocation)-" != "" ? "\(self.temp.zoneLocation)-": "-"
            
            if self.temp.emerge { id.append(self.temp.emergeType == "nest" ? "N" : "F") }
            if self.temp.existingNestDisturbed { id.append(self.temp.existingNestDisturbedType == "disturbed" ? "D" : "R") }

            //            id.append(self.data.hatching ? "H" : "")

            id.append(self.temp.turtle ? "T" : "")
            
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "-yyyyMMdd-HHmmss-"
            
            id.append(dateFormatter.string(from: Date()))
            id.append(self.defaults.string(forKey: "userID") ?? "NOUSER")
            self.temp.id = id
            
            
            do {
                try self.realm.write {
                    self.realm.add(self.temp)
                    self.realm.delete(self.data!)
                }
                
                self.data = Observation()
            } catch {
                print("Error saving data, \(error) END")
            }
            
            self.dispatchGroup.leave()
            print("juoiu)")
            
            self.dispatchGroup.wait()
            
            DispatchQueue.main.async {
                print("About to pop vc.")
                self.navigationController?.popViewController(animated: true)

            }
            
        })) // Ends closure begun in line 392
        alert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: nil))
        
        present(alert, animated: true)
       
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        print("Deleting observation")
        
        let alert = UIAlertController(title: "Delete this observation?", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
            
            self.dispatchGroup.enter()
            
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
            temp.lat = location.coordinate.latitude
            temp.lon = location.coordinate.longitude
            let latAsStr = String(format: "%.2f", temp.lat)
            let lonAsStr = String(format: "%.2f", temp.lon)
            let accAsStr = String(format: "%.1f", location.horizontalAccuracy)
            locationButton.setTitle("\(latAsStr), \(lonAsStr), ± \(accAsStr)m", for: .normal)
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
                photoImageView1.image = imageTaken
                temp.image1 = imgRef
            case 2:
                photoImageView2.image = imageTaken
                temp.image2 = imgRef
            case 3:
                photoImageView3.image = imageTaken
                temp.image3 = imgRef
            case 4:
                photoImageView4.image = imageTaken
                temp.image4 = imgRef
            case 5:
                photoImageView5.image = imageTaken
                temp.image5 = imgRef
            default:
                print("error BOUBOUBOBUOBUBOUBOBUOUBBUBUBO")
            }
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
}
