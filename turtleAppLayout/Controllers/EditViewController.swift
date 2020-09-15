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
    
    @IBOutlet weak var zoneButton: UIButton!
    @IBOutlet weak var propertyButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var accuracyLabel: UILabel!
    @IBOutlet weak var nestButton: UIButton!
    @IBOutlet weak var disturbedButton: UIButton!
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
            print("eoirhoerihwoeirho")
        }
        
        
        // Do any additional setup after loading the view.
        //        locationManager.requestWhenInUseAuthorization()  Already did this, right?
        locationManager.delegate = self
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        //        imagePicker.sourceType = .camera LET USER SELECT GALLERY OR CAMERA
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
        temp.accuracy = data!.accuracy
        
        temp.nest = data!.nest
        temp.turtle = data!.turtle
        temp.existingNestDisturbed = data!.existingNestDisturbed
        
        temp.nestType = data!.nestType
        temp.turtleType = data!.turtleType
        temp.existingNestDisturbedType = data!.existingNestDisturbedType
        
        temp.hatching = data!.hatching
        
        temp.numSuccess = data!.numSuccess
        temp.numStranded = data!.numStranded
        temp.numDead = data!.numDead
        
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
            locationButton.setTitle("", for: .normal)
            
        }
        nestButton.setTitle(data!.nest ? data?.nestType : "", for: .normal)
        disturbedButton.setTitle(data!.existingNestDisturbed ? data?.existingNestDisturbedType : "", for: .normal)
        turtleButton.setTitle(data!.turtle ? data?.turtleType : "", for: .normal)
        //        hatchingButton.setTitle(data!.hatching ? data?.hatchingType : "", for: .normal)
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
        
        
        
        //  Trying to load the images but I cannot get the document directory path!  Saving in realm but it comes back as nothing.
        //
        //
        //        if data != nil {
        //        if data?.image1 != nil {
        //            print("data?.image1 is:")
        //            print(data?.image1)
        ////            let url = NSURL(string: data!.image1)'
        //            print(data!.docDirPath)  PROBLEM IS HERE, THIS IS ""
        //            print("\(data!.docDirPath)/\(data!.image1).jpg")
        //            let url = URL(fileReferenceLiteralResourceName: "\(data!.docDirPath)/\(data!.image1).jpg")
        //            let imageToLoadData = NSData(contentsOf: url)
        //            if imageToLoadData != nil {
        //                let imageToLoad = UIImage(data: imageToLoadData! as Data )
        //                photoImageView1.image = imageToLoad
        //            } else {
        //                print("imageToLoadData is nil")
        //            }
        //
        //
        //        } else {
        //            print("data?.image1 is nil")
        //            }
        //        } else {
        //            print("data is nil")
        //        }
        //
        
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
        
        
    }
    
    @IBAction func zoneButtonPressed(_ sender: UIButton) {
        print("zone")
        print(temp)
        
        
        let alert = UIAlertController(title: "SELECT A ZONE", message: "", preferredStyle: .alert)
        
        for zone in K.zones {
            let action = UIAlertAction(title: zone, style: .default) { (_) in
                if self.temp.zoneLocation != zone {
                    self.temp.property = ""
                    self.propertyButton.setTitle("", for: .normal)
                }
                sender.setTitle(zone, for: .normal)
                self.temp.zoneLocation = zone
                
            }
            alert.addAction(action)
        }
        
        alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { (_) in
            sender.setTitle("", for: .normal)
            self.temp.zoneLocation = ""
            self.temp.property = ""
            self.propertyButton.setTitle("", for: .normal)
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
    
    @IBAction func nestButtonPressed(_ sender: UIButton) {
        print("nest")
    }
    
    @IBAction func disturbedButtonPressed(_ sender: UIButton) {
        print("disturbed")
        
    }
    
    @IBAction func turtleButtonPressed(_ sender: UIButton) {
        print("turtle")
        
    }
    
    @IBAction func hatchingButtonPressed(_ sender: UIButton) {
        print("hatching")
    }
    
    @IBAction func photo1ButtonPressed(_ sender: UIButton) {
        print("click1")
    }
    
    @IBAction func photo2ButtonPressed(_ sender: UIButton) {
        print("click2")
    }
    
    @IBAction func photo3ButtonPressed(_ sender: UIButton) {
        print("click3")
        
    }
    
    @IBAction func photo4ButtonPressed(_ sender: UIButton) {
        print("click4")
    }
    
    @IBAction func photo5ButtonPressed(_ sender: UIButton) {
        print("click5")
        
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        print("DONE!!!")
        
        let alert = UIAlertController(title: "SAVE THIS OBSERVATION AND CLEAR ALL FIELDS?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (_) in
            
            self.temp.comments = self.commentsTextView.text ?? ""
            
            // creat id
            var id = "\(self.temp.zoneLocation)-" != "" ? "\(self.temp.zoneLocation)-": "-"
            
            if self.temp.nest { id.append(self.temp.nestType == "nest" ? "N" : "F") }
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
                
                //                        //Reset all fields if successfully saved
                //                        self.locationButton.setTitle("Get GPS Location", for: .normal)
                //                        self.nestButton.setTitle("Nest?", for: .normal)
                //                        self.existingNestButton.setTitle("Disturb/Reloc?", for: .normal)
                //                        self.turtleButton.setTitle("Turtle?", for: .normal)
                //                        self.hatchingButton.setTitle("Hatching", for: .normal)
                //                        self.zoneButton.setTitle("Zone?", for: .normal)
                //                        self.propertyButton.setTitle("Property/Lot?", for: .normal)
                //                        self.commentsTextView.text = ""
                //        //                self.photoButton.setTitle("", for: .normal)  What's wrong here?
                //                        self.photoImage1.image = UIImage(systemName: "camera.fill")
                //                        self.photoImage2.image = UIImage(systemName: "camera.fill")
                //                        self.photoImage3.image = UIImage(systemName: "camera.fill")
                //                        self.photoImage4.image = UIImage(systemName: "camera.fill")
                //                        self.photoImage5.image = UIImage(systemName: "camera.fill")
                
                self.data = Observation()
            } catch {
                print("Error saving data, \(error) END")
            }
            
        })) // Ends closure begun in line 279
        alert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: nil))
        
        present(alert, animated: true)
        alert.view.tintColor = UIColor.black
    }
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        print("deeeeeleting")
        
        let alert = UIAlertController(title: "Delete observation?", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: { (_) in
            do {
                try self.realm.write{
                    self.realm.delete(self.data!)
                }
            } catch {
                print("ERror deleting observation: \(error)")
            }
            
            //Go back to main menu
        }))
        
        alert.addAction(UIAlertAction(title: "no", style: .default, handler: nil))
        
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
                data!.image1 = imgRef
            case 2:
                photoImageView2.image = imageTaken
                data!.image2 = imgRef
            case 3:
                photoImageView3.image = imageTaken
                data!.image3 = imgRef
            case 4:
                photoImageView4.image = imageTaken
                data!.image4 = imgRef
            case 5:
                photoImageView5.image = imageTaken
                data!.image5 = imgRef
            default:
                print("error BOUBOUBOBUOBUBOUBOBUOUBBUBUBO")
            }
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
}
