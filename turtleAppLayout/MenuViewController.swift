//
//  ViewController.swift
//  turtleAppLayout
//
//  Created by Olivia James on 8/25/20.
//  Copyright © 2020 Sebastien James. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func languageButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func newObs(_ sender: UIButton) {
        //Present Blank ObsController

    }
    
    @IBAction func editObs(_ sender: UIButton) {
        //PrepareForSegue with data from local Realm database, then present
    }
    
    @IBAction func sync(_ sender: UIButton) {
        //Sync with Firebase and upload observations from phone
    }
    
    
}

