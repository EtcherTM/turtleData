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
            cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! ListCell
            cell.textLabel?.text = listOfObservations[indexPath.row].id
            cell.backgroundColor = .green
        case NoActivityTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! ListCell
            cell.textLabel?.text = noActivityReports[indexPath.row].id
            cell.backgroundColor = .blue
        default:
                print("Error getting number of rows.")
            
        }
        
        
        return cell
    }
}



