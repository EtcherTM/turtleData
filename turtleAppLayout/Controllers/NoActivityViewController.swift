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
    let defaults = UserDefaults.standard
    var noAct = NoActivityReport()

    
    
    @IBOutlet weak var aButton: UIButton!
    @IBOutlet weak var bButton: UIButton!
    @IBOutlet weak var cButton: UIButton!
    @IBOutlet weak var dButton: UIButton!
    @IBOutlet weak var eButton: UIButton!
    @IBOutlet weak var fButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noAct.aNoActivity = false
        noAct.bNoActivity = false
        noAct.cNoActivity = false
        noAct.dNoActivity = false
        noAct.eNoActivity = false
        noAct.fNoActivity = false
    }
    
    @IBAction func aButtonPressed(_ sender: UIButton) {
        noAct.aNoActivity = !noAct.aNoActivity
        if noAct.aNoActivity == true {
            sender.setTitle("A ✓", for: .normal)
        } else {
            sender.setTitle("A", for: .normal)
        }
    }
    
    @IBAction func bButtonPressed(_ sender: UIButton) {
        noAct.bNoActivity = !noAct.bNoActivity
        if noAct.bNoActivity == true {
            sender.setTitle("B ✓", for: .normal)
        } else {
            sender.setTitle("B", for: .normal)
        }
    }
    @IBAction func cButtonPressed(_ sender: UIButton) {
        noAct.cNoActivity = !noAct.cNoActivity
        if noAct.cNoActivity == true {            sender.setTitle("C ✓", for: .normal)
        } else {
            sender.setTitle("C", for: .normal)
        }
    }
    
    @IBAction func dButtonPressed(_ sender: UIButton) {
         noAct.dNoActivity = !noAct.dNoActivity
         if noAct.dNoActivity == true {
            sender.setTitle("D ✓", for: .normal)
        } else {
            sender.setTitle("D", for: .normal)
        }
    }
    @IBAction func eButtonPressed(_ sender: UIButton) {
        noAct.eNoActivity = !noAct.eNoActivity
        if noAct.eNoActivity == true {
            sender.setTitle("E ✓", for: .normal)
        } else {
            sender.setTitle("E", for: .normal)
        }
    }
    @IBAction func fButtonPressed(_ sender: UIButton) {
        noAct.fNoActivity = !noAct.fNoActivity
        if noAct.fNoActivity == true {
            sender.setTitle("F ✓", for: .normal)
        } else {
            sender.setTitle("F", for: .normal)
        }
    }
    
    
    
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        
        print(noAct)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHH"

        
        if noAct.aNoActivity == true {
            var id = ""
            id.append("A")
            id.append(dateFormatter.string(from: Date()))
            id.append(self.defaults.string(forKey: "userID") ?? "NOUSER")
            id.append("NOACTIVITY")
            print("The new observation ID is: \(id)")
        }
        
        if noAct.bNoActivity == true {
            var id = ""
            id.append("B")
            id.append(dateFormatter.string(from: Date()))
            id.append(self.defaults.string(forKey: "userID") ?? "NOUSER")
            id.append("NOACTIVITY")
            print("The new observation ID is: \(id)")

        }
        
        if noAct.cNoActivity == true {
            var id = ""
            id.append("C")
            id.append(dateFormatter.string(from: Date()))
            id.append(self.defaults.string(forKey: "userID") ?? "NOUSER")
            id.append("NOACTIVITY")
            print("The new observation ID is: \(id)")

        }
        
        if noAct.dNoActivity == true {
            var id = ""
            id.append("D")
            id.append(dateFormatter.string(from: Date()))
            id.append(self.defaults.string(forKey: "userID") ?? "NOUSER")
            id.append("NOACTIVITY")
            print("The new observation ID is: \(id)")

        }
        
        if noAct.eNoActivity == true {
            var id = ""
            id.append("E")
            id.append(dateFormatter.string(from: Date()))
            id.append(self.defaults.string(forKey: "userID") ?? "NOUSER")
            id.append("NOACTIVITY")
            print("The new observation ID is: \(id)")

        }
        
        if noAct.fNoActivity == true {
            var id = ""
            id.append("F")
            id.append(dateFormatter.string(from: Date()))
            id.append(self.defaults.string(forKey: "userID") ?? "NOUSER")
            id.append("NOACTIVITY")
            print("The new observation ID is: \(id)")

        }
        
        self.dismiss(animated: true, completion: createLabel)
            
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    func createLabel() {

            var noActButtonText = "No Activity in Zone: "
            
            if noAct.aNoActivity {
                noActButtonText.append("A")
            }
            if noAct.bNoActivity {
                noActButtonText.append("B")
            }
            if noAct.cNoActivity {
                noActButtonText.append("C")
            }
            if noAct.dNoActivity {
                noActButtonText.append("D")
            }
            if noAct.eNoActivity {
                noActButtonText.append("E")
            }
            if noAct.fNoActivity {
                noActButtonText.append("F")
            }
            
            print(noActButtonText)
            
            
        }
//        sender.destination.
        // Pass the selected object to the new view controller.
    }



