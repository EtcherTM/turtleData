//
//  ViewController.swift
//  TurtleApp
//
//  Created by Olivia James on 8/15/20.
//  Copyright © 2020 Sebastien James. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    
    @IBAction func observationButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toObservation", sender: self)
    }
    
    @IBAction func syncButtonPressed(_ sender: Any) {
        
    }
    
}

