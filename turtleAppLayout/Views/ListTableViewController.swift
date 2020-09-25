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
        
        if var index = Int(String(observation.property.dropFirst().dropFirst())) {
            index -= 1
            switch observation.property.first {
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
        
        
        var type: String = ""
        
        if observation.emerge {
            type = "New Nest "
        }
        if observation.existingNestDisturbed {
            type.append("Existing Nest ")
        }
        if observation.hatchingBool {
            type.append("Hatching ")
        }
        if observation.turtle {
            type.append("Turtle")
        }
        
        let dateFormatter = DateFormatter()
         
         dateFormatter.dateFormat = "dd-MM"
         
        let itemDate = dateFormatter.string(from: observation.date)
        
        cell.cellLabel?.text = "\(observation.property == "" ? observation.zoneLocation : observation.property):  \(type) \(itemDate) (\(propertyDesc))\n \(observation.comments)\n\(observation.id)"
        
        let images = [observation.image1, observation.image2, observation.image3, observation.image4, observation.image5]
        
        for image in 0...4 {
            if images[image] != "" {
                if var documentsPathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                    
                    documentsPathURL.appendPathComponent("\(images[image]).jpg")
                    
                    
                    print(documentsPathURL)
                    let imageToLoad = UIImage(contentsOfFile: documentsPathURL.path) ?? UIImage()
                    
                    
                    switch image {
                    case 0:
                        cell.photoImage1.image = imageToLoad
                    case 1:
                        cell.photoImage2.image = imageToLoad
                    case 2:
                        cell.photoImage3.image = imageToLoad
                    case 3:
                        cell.photoImage4.image = imageToLoad
                    case 4:
                        cell.photoImage5.image = imageToLoad
                    default:
                        print("Error loading images")
                    }
                    
                    
                }
            }
        }

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row selected")
        performSegue(withIdentifier: "Edit", sender: self)
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


