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
        
        if data?.id != nil {
            title = "Edit \(data!.id)"
            fillTextFields()
        }
        else {
            //            put an alert here?
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
        zoneButton.setTitle(data!.zoneLocation, for: .normal)
        var propertyDesc = ""
        //        if data!.property != nil {
        //            let index = Int(String(data!.property.dropFirst().dropFirst()))! - 1 // Checking for nil but still fails
        //            switch data?.property.first {
        //            case "A":
        //                propertyDesc = K.propertiesInA[index].1
        //            case "B":
        //            propertyDesc = K.propertiesInB[index].1
        //            case "C":
        //                propertyDesc = K.propertiesInC[index].1
        //            case "D":
        //                propertyDesc = K.propertiesInD[index].1
        //            case "E":
        //                propertyDesc = K.propertiesInE[index].1
        //            case "F":
        //                propertyDesc = K.propertiesInF[index].1
        //            default:
        //                propertyDesc = "No property/lot selected"
        //            }
        //        }
        //        propertyButton.setTitle(propertyDesc, for: .normal)
        
        if data!.lat != 0.0 || data!.lon != 0.0 {
            let latAsStr = String(format: "%.2f", data!.lat)
            let lonAsStr = String(format: "%.2f", data!.lon)
            //        let accAsStr = String(format: "%.1f", location.horizontalAccuracy)
            locationButton.setTitle("\(latAsStr), \(lonAsStr) ± ____ m", for: .normal)
        } else {
            locationButton.setTitle("", for: .normal)
            
        }
        nestButton.setTitle(data!.nest ? data?.nestType : "", for: .normal)
        disturbedButton.setTitle(data!.disturbed ? data?.disturbedOrRelocated : "", for: .normal)
        turtleButton.setTitle(data!.turtle ? data?.turtleType : "", for: .normal)
        hatchingButton.setTitle(data!.hatching ? data?.hatchingType : "", for: .normal)
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
    }
    @IBAction func propertyButtonPressed(_ sender: UIButton) {
        print("property")
        
    }
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        print("location")
        
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
    }
}


//MARK:- Location Extension

extension EditViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            //            data.lat = location.coordinate.latitude
            //            data.lon = location.coordinate.longitude
            //            let latAsStr = String(format: "%.2f", data.lat)
            //            let lonAsStr = String(format: "%.2f", data.lon)
            //            let accAsStr = String(format: "%.1f", location.horizontalAccuracy)
            //            locationButton.setTitle("\(latAsStr), \(lonAsStr), ± \(accAsStr)m", for: .normal)
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
