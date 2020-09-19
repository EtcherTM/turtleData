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

        var type: String = ""
        
        if observation.nest {
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
        
        cell.cellLabel?.text = "\(observation.property == "" ? observation.zoneLocation : observation.property):  \(type) \(itemDate) \(observation.comments)\n\(observation.id)"

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row selected")
        performSegue(withIdentifier: "Edit", sender: self)
    }


}
