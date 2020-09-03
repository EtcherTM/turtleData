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
        }
    }
    
    @IBAction func bButtonPressed(_ sender: UIButton) {
    }
    @IBAction func cButtonPressed(_ sender: UIButton) {
    }
    @IBAction func dButtonPressed(_ sender: UIButton) {
    }
    @IBAction func eButtonPressed(_ sender: UIButton) {
    }
    @IBAction func fButtonPressed(_ sender: UIButton) {
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
