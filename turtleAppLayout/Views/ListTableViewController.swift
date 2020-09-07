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
        
    var listOfObservations = try! Realm().objects(Observation.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(listOfObservations)
        tableView.register(UINib(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")


        // Uncomment the following line to preserve selection between presentations
//         self.clearsSelectionOnViewWillAppear = false

    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfObservations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Made it to cellforrowat")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! ListCell

        let observation = listOfObservations[indexPath.row]

        var type: String = ""
        
        if observation.nest {
            type = "Nest "
        }
        if observation.disturbed {
            type.append("Disturbed or Relocated")
        }
        if observation.hatching {
            type.append("Hatching ")
        }
        if observation.turtle {
            type.append("Turtle")
        }
        
        cell.cellLabel?.text = "\(observation.zoneLocation):  \(type) \(observation.comments)"

        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("Row selected")
        performSegue(withIdentifier: "Edit", sender: self)
    }

}
