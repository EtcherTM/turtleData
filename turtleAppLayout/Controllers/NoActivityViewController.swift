//
//  NoActivityViewController.swift
//  turtleAppLayout
//
//  Created by Olivia James on 9/3/20.
//  Copyright © 2020 Sebastien James. All rights reserved.
//

import UIKit
import CoreLocation
import RealmSwift


class NoActivityViewController: UIViewController {

    var data = Observation()
    
    @IBOutlet weak var aButton: UIButton!
    @IBOutlet weak var bButton: UIButton!
    @IBOutlet weak var cButton: UIButton!
    @IBOutlet weak var dButton: UIButton!
    @IBOutlet weak var eButton: UIButton!
    @IBOutlet weak var fButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func aButtonPressed(_ sender: UIButton) {

        data.aNoActivity = !data.aNoActivity
        if data.aNoActivity == true {
            sender.setTitle("A ✓", for: .normal)
        } else {
            sender.setTitle("A", for: .normal)
        }
    }
    
    @IBAction func bButtonPressed(_ sender: UIButton) {
        data.bNoActivity = !data.bNoActivity
        if data.bNoActivity == true {
            sender.setTitle("B ✓", for: .normal)
        } else {
            sender.setTitle("B", for: .normal)
        }
    }
    @IBAction func cButtonPressed(_ sender: UIButton) {
        data.cNoActivity = !data.cNoActivity
        if data.cNoActivity == true {
            sender.setTitle("C ✓", for: .normal)
        } else {
            sender.setTitle("C", for: .normal)
        }
    }
    
    @IBAction func dButtonPressed(_ sender: UIButton) {
        data.dNoActivity = !data.dNoActivity
        if data.dNoActivity == true {
            sender.setTitle("D ✓", for: .normal)
        } else {
            sender.setTitle("D", for: .normal)
        }
    }
    @IBAction func eButtonPressed(_ sender: UIButton) {
        data.eNoActivity = !data.eNoActivity
        if data.eNoActivity == true {
            sender.setTitle("E ✓", for: .normal)
        } else {
            sender.setTitle("E", for: .normal)
        }
    }
    @IBAction func fButtonPressed(_ sender: UIButton) {
        data.fNoActivity = !data.fNoActivity
        if data.fNoActivity == true {
            sender.setTitle("F ✓", for: .normal)
        } else {
            sender.setTitle("F", for: .normal)
        }
    }
    
    
    
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: createLabel)
//        self.performSegue(withIdentifier: "NoActivityToHome", sender: self)
    
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    
     func createLabel() {

            data.noActivityValue = "No Activity in Zone: "
            
            if data.aNoActivity {
                data.noActivityValue.append("A")
            }
            if data.bNoActivity {
                data.noActivityValue.append("B")
            }
            if data.cNoActivity {
                data.noActivityValue.append("C")
            }
            if data.dNoActivity {
                data.noActivityValue.append("D")
            }
            if data.eNoActivity {
                data.noActivityValue.append("E")
            }
            if data.fNoActivity {
                data.noActivityValue.append("F")
            }
            
            print(data.noActivityValue ?? "No zone selected")
            
            
        }
//        sender.destination.
        // Pass the selected object to the new view controller.
    }



