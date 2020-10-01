//
//  ListOfObsTableViewController.swift
//  turtleAppLayout
//
//  Created by Olivia James on 9/6/20.
//  Copyright © 2020 Sebastien James. All rights reserved.
//

import UIKit
import RealmSwift

class ListTableViewController: UITableViewController {
        
    var listOfObservations = try! Realm().objects(Observation.self).sorted(byKeyPath: "zoneLocation")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(listOfObservations)
        tableView.register(UINib(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var selectedObservation: Observation
        let indexPath = tableView.indexPathForSelectedRow
        if segue.destination is EditViewController
        {
            let vc = segue.destination as? EditViewController
            selectedObservation = listOfObservations[indexPath!.row]
            vc?.data = selectedObservation
            
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfObservations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! ListCell

        let observation = listOfObservations[indexPath.row]
        var propertyDesc = ""
        var newBackgroundColor = UIColor()
        var newFontColor = UIColor()
        
        if var index = Int(String(observation.property.dropFirst().dropFirst())) {
            index -= 1
            switch observation.property.first {
            case "A":
                propertyDesc = K.propertiesInA[index].1
                newBackgroundColor = UIColor(named: "Dull red") ?? #colorLiteral(red: 0.9394575357, green: 0.08814223856, blue: 0, alpha: 1)
                newFontColor = .white
                
            case "B":
                propertyDesc = K.propertiesInB[index].1
                newBackgroundColor = UIColor(named: "Dull orange") ?? .orange
                newFontColor = .white
            case "C":
                propertyDesc = K.propertiesInC[index].1
                newBackgroundColor = UIColor(named: "Dull yellow") ?? #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1)
                newFontColor = .black
            case "D":
                propertyDesc = K.propertiesInD[index].1
                newBackgroundColor = UIColor(named: "Dull green")  ?? #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
                newFontColor = .white
            case "E":
                propertyDesc = K.propertiesInE[index].1
                newBackgroundColor = UIColor(named: "Dull blue ")  ?? #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
                newFontColor = .white
            case "F":
                propertyDesc = K.propertiesInF[index].1
                newBackgroundColor = UIColor(named: "Dull purple") ?? #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
                newFontColor = .white
//            case "G":
                
            default:
                propertyDesc = "No property/lot selected"
            }
        }
        
        
        
        var type: String = ""
        
        if observation.emergeType == "nest" {
            type = "New Nest "
        } else {
            if observation.emergeType == "false nest" {
            type = "False Nest "
            } else {
                if observation.emergeType == "false crawl" {
                    type = "False Crawl"
                }
                }
        }
        if observation.existingNestDisturbed {
            type.append("Existing Nest ")
        }
        
        if observation.turtle {
            type.append("Turtle")
        }
        if observation.hatchingBool {
            type.append("Hatching ")
        }

        if observation.id.count < 3 {
            type.append("Other")
        }

        
        let dateFormatter = DateFormatter()
         
         dateFormatter.dateFormat = "dd-MM"
         
        let itemDate = dateFormatter.string(from: observation.date)
        
        cell.cellLabel?.text = "\(observation.property == "" ? observation.zoneLocation : observation.property):  \(type) \(itemDate) (\(propertyDesc))\n \(observation.comments)\n\(observation.id)"
        
        let images = [observation.image1, observation.image2, observation.image3, observation.image4, observation.image5]
        
//        var firstRound: Data
        var compressedImageToLoad: Data
        
        for image in 0...4 {
            if images[image] != "" {
                if var documentsPathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                    
                    documentsPathURL.appendPathComponent("\(images[image]).jpg")
                    
                    print(documentsPathURL)
                    
                    
                    let imageToLoad = UIImage(contentsOfFile: documentsPathURL.path) ?? UIImage()
//                    if let firstRound = imageToLoad.jpeg(.lowest) {}
                    if let compressedImageToLoad = imageToLoad.jpeg(.lowest) {
                         switch image {
                               case 0:
                //                               cell.photoImage1.image = imageToLoad
                                   cell.photoImage1.image = UIImage(data: compressedImageToLoad)
                               case 1:
                //                                   cell.photoImage2.image = imageToLoad
                            cell.photoImage2.image = UIImage(data: compressedImageToLoad)

                               case 2:
                //                                   cell.photoImage3.image = imageToLoad
                            cell.photoImage3.image = UIImage(data: compressedImageToLoad)

                               case 3:
                //                                   cell.photoImage4.image = imageToLoad
                            cell.photoImage4.image = UIImage(data: compressedImageToLoad)

                               case 4:
                //                                   cell.photoImage5.image = imageToLoad
                            cell.photoImage5.image = UIImage(data: compressedImageToLoad)

                               default:
                                   print("Error loading images")
                               }
                    }
                }
            }
        } // Ends for loop

        cell.cellView.backgroundColor = newBackgroundColor
        cell.cellLabel.textColor = newFontColor
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row selected")
        performSegue(withIdentifier: "ListToEdit", sender: self)
    }


    @IBAction func createPDFPressed(_ sender: Any) {
        let pdfFilePath = self.tableView.exportAsPdfFromTable()
        print(pdfFilePath)
    }
}

extension UITableView {
    
    // Export pdf from UITableView and save pdf in drectory and return pdf file path
    func exportAsPdfFromTable() -> String {
        
        let originalBounds = self.bounds
        self.bounds = CGRect(x:originalBounds.origin.x, y: originalBounds.origin.y, width: self.contentSize.width, height: self.contentSize.height)
        let pdfPageFrame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.contentSize.height)
        
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, pdfPageFrame, nil)
        UIGraphicsBeginPDFPageWithInfo(pdfPageFrame, nil)
        guard let pdfContext = UIGraphicsGetCurrentContext() else { return "" }
        self.layer.render(in: pdfContext)
        UIGraphicsEndPDFContext()
        self.bounds = originalBounds
        // Save pdf data
        return self.saveTablePdf(data: pdfData)
        
    }
    
    // Save pdf file in document directory
    func saveTablePdf(data: NSMutableData) -> String {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docDirectoryPath = paths[0]
        let pdfPath = docDirectoryPath.appendingPathComponent("tablePdf.pdf")
        if data.write(to: pdfPath, atomically: true) {
            return pdfPath.path
        } else {
            return ""
        }
        
    }
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0.0
        case low     = 0.13
        case medium  = 0.25
        case high    = 0.37
        case highest = 0.5
    }

    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}
