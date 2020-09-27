//
//  TwoTableViewController.swift
//  turtleAppLayout
//
//  Created by Olivia James on 9/25/20.
//  Copyright © 2020 Sebastien James. All rights reserved.
//

import UIKit
import RealmSwift

class TwoTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var listOfObservations = try! Realm().objects(Observation.self).sorted(byKeyPath: "zoneLocation")
    
    var noActivityReports = try! Realm().objects(NoActivityReport.self)
    
    @IBOutlet weak var ListTableView: UITableView!
    @IBOutlet weak var NoActivityTableView: UITableView!

    override func viewDidLoad() {
    super.viewDidLoad()
        print(listOfObservations)
        print(noActivityReports)
        ListTableView.register(UINib(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        NoActivityTableView.register(UINib(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
            
        ListTableView.rowHeight = UITableView.automaticDimension
        ListTableView.estimatedRowHeight = 300
        
        ListTableView.delegate = self
        NoActivityTableView.delegate = self
        ListTableView.dataSource = self
        NoActivityTableView.dataSource = self
        
    }
 
    override func viewWillAppear(_ animated: Bool) {
        ListTableView.reloadData()
        NoActivityTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var selectedObservation: Observation
        let indexPath = ListTableView.indexPathForSelectedRow
        if segue.destination is EditViewController
        {
            let vc = segue.destination as? EditViewController
            selectedObservation = listOfObservations[indexPath!.row]
            vc?.data = selectedObservation
            
        }
//        if segue.destination is EditNoActivityReports
//        {
//
//        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRow = 1
        switch tableView {
        case ListTableView:
            numberOfRow = self.listOfObservations.count
        case NoActivityTableView:
            numberOfRow = self.noActivityReports.count
        default:
                print("Error getting number of rows.")
            
        }
        
        return numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch tableView {
        case ListTableView:
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
                            newBackgroundColor = #colorLiteral(red: 0.9394575357, green: 0.08814223856, blue: 0, alpha: 1)
                            newFontColor = .white
                            
                        case "B":
                            propertyDesc = K.propertiesInB[index].1
                            newBackgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
                            newFontColor = .white
                        case "C":
                            propertyDesc = K.propertiesInC[index].1
                            newBackgroundColor = #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1)
                            newFontColor = .black
                        case "D":
                            propertyDesc = K.propertiesInD[index].1
                            newBackgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
                            newFontColor = .white
                        case "E":
                            propertyDesc = K.propertiesInE[index].1
                            newBackgroundColor = .orange
                            newFontColor = .white
                        case "F":
                            propertyDesc = K.propertiesInF[index].1
                            newBackgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
                            newFontColor = .black
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
                    

        case NoActivityTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! ListCell
            cell.textLabel?.text = noActivityReports[indexPath.row].id
            cell.backgroundColor = .blue
            
            return cell
        default:
                print("Error getting number of rows.")
            
        }
        
        return cell
    }
}



