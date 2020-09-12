//
//  HatchingViewController.swift
//  turtleAppLayout
//
//  Created by Olivia James on 9/11/20.
//  Copyright © 2020 Sebastien James. All rights reserved.
//

import UIKit

class HatchingViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    let defaults = UserDefaults.standard
    var hatchingTemp = true
    var hatchingTypeTemp = ""
    var numSuccessTemp = 0
    var numStrandedTemp = 0
    var numDeadTemp = 0
    

    @IBOutlet weak var noProblemButton: UIButton!
    @IBOutlet weak var lightsButton: UIButton!
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var sewerButton: UIButton!
    @IBOutlet weak var plantsButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    
    @IBOutlet weak var successButton: UIButton!
    @IBOutlet weak var strandedButton: UIButton!
    @IBOutlet weak var deadButton: UIButton!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
   
    @IBAction func noProblemButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func lightsButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func trashButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func sewerButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func plantsButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func otherButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func successButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func strandedButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func deadButtonPressed(_ sender: UIButton) {
    }
    
    
    
}

