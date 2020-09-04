//
//  NoActivityViewController.swift
//  turtleAppLayout
//
//  Created by Olivia James on 9/3/20.
//  Copyright © 2020 Sebastien James. All rights reserved.
//

import UIKit



class NoActivityViewController: UIViewController {

    @IBOutlet weak var aButton: UIButton!
    @IBOutlet weak var bButton: UIButton!
    @IBOutlet weak var cButton: UIButton!
    @IBOutlet weak var dButton: UIButton!
    @IBOutlet weak var eButton: UIButton!
    @IBOutlet weak var fButton: UIButton!

    var data = Observation()
    
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
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
