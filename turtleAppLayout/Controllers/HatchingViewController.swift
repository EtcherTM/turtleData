//
//  HatchingViewController.swift
//  turtleAppLayout
//
//  Created by Olivia James on 9/11/20.
//  Copyright © 2020 Sebastien James. All rights reserved.
//

import UIKit
import RealmSwift

class HatchingViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    var hisVariable: String?
//    Need to define realm, can we use this for both new and reviewed
    var obs : Observation?
    let defaults = UserDefaults.standard
    var hatch = Hatching()

    var hatchingExistsTemp = true
    var hatchingTypeTemp = ""
    var hatchingNoProblemsTemp : Bool = false
    var hatchingLightsTemp : Bool = false
    var hatchingTrashTemp : Bool = false
    var hatchingSewerTemp : Bool = false
    var hatchingPlantsTemp : Bool = false
    var hatchingOtherTemp : Bool = false
    
    var numSuccessTemp = 0
    var numStrandedTemp = 0
    var numDeadTemp = 0

    let dispatchGroup = DispatchGroup()
    
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
    @IBOutlet weak var resetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "HATCHING PROBLEMS"
        if let hatching = obs?.hatchingDetails {
            print(hatching)
            noProblemButton.setTitle(hatching.noProblems ? "No Problems ✓" : "No Problems", for: .normal)
            print(hatching.noProblems ? "No Problems ✓" : "No Problems")
            lightsButton.setTitle(hatching.lights ? "Lights ✓" : "Lights", for: .normal)
            trashButton.setTitle(hatching.trash ? "Trash ✓" : "Trash", for: .normal)
            sewerButton.setTitle(hatching.sewer ? "Sewer ✓" : "Sewer", for: .normal)
            plantsButton.setTitle(hatching.plants ? "Plants ✓" : "Plants", for: .normal)
            otherButton.setTitle(hatching.other ? "Other ✓" : "Other", for: .normal)
            successButton.setTitle("\(hatching.numSuccess) Success", for: .normal)
            strandedButton.setTitle("\(hatching.numStranded) Stranded", for: .normal)
            deadButton.setTitle("\(hatching.numDead) Dead", for: .normal)
            
            hatchingExistsTemp = true
            hatchingTypeTemp = ""
            hatchingNoProblemsTemp = hatching.noProblems
            hatchingLightsTemp = hatching.lights
            hatchingTrashTemp = hatching.trash
            hatchingSewerTemp = hatching.sewer
            hatchingPlantsTemp = hatching.plants
            hatchingOtherTemp = hatching.other
            
            numSuccessTemp = hatching.numSuccess
            numStrandedTemp = hatching.numStranded
            numDeadTemp = hatching.numDead
        }
    }
    
    @IBAction func noProblemButtonPressed(_ sender: UIButton) {
        hatchingNoProblemsTemp = !hatchingNoProblemsTemp
        if hatchingNoProblemsTemp {
            sender.setTitle("No Problems ✓", for: .normal)
            print("No problems")
        } else {
            sender.setTitle("No Problems", for: .normal)
            print("Problems")
        }
    }
    
    @IBAction func lightsButtonPressed(_ sender: UIButton) {
        hatchingLightsTemp = !hatchingLightsTemp
        if hatchingLightsTemp {
            sender.setTitle("Lights ✓", for: .normal)
            print("Light problem")
        } else {
            sender.setTitle("Lights", for: .normal)
            print("No light problem")
        }
    }
    
    @IBAction func trashButtonPressed(_ sender: UIButton) {
        hatchingTrashTemp = !hatchingTrashTemp
        if hatchingTrashTemp {
            sender.setTitle("Trash ✓", for: .normal)
            print("Trash problem")
        } else {
            sender.setTitle("Trash", for: .normal)
            print("No Trash problem")
        }
    }
    
    @IBAction func sewerButtonPressed(_ sender: UIButton) {
    hatchingSewerTemp = !hatchingSewerTemp
    if hatchingSewerTemp {
        sender.setTitle("Sewer ✓", for: .normal)
        print("sewer problem")
    } else {
        sender.setTitle("Sewer", for: .normal)
        print("No sewer problem")
    }
    }
    
    @IBAction func plantsButtonPressed(_ sender: UIButton) {
        hatchingPlantsTemp = !hatchingPlantsTemp
        if hatchingPlantsTemp {
            sender.setTitle("Plants ✓", for: .normal)
            print("plants problem")
        } else {
            sender.setTitle("Plants", for: .normal)
            print("No Plants problem")
        }
    }
    
    @IBAction func otherButtonPressed(_ sender: UIButton) {
        hatchingOtherTemp = !hatchingOtherTemp
          if hatchingOtherTemp {
              sender.setTitle("Other ✓", for: .normal)
              print("Other problem")
          } else {
              sender.setTitle("Other", for: .normal)
              print("No other problem")
          }
        
    }
    
    @IBAction func successButtonPressed(_ sender: UIButton) {

        var myTextField : UITextField?
        let alert = UIAlertController.init(title: "Estimate the number of babies that went unassisted to ocean", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            // make sure your outside any property should be accessed with self here
            myTextField = textField
            //Important step assign textfield delegate to self
            myTextField?.delegate = self
            myTextField?.placeholder = "0"
            myTextField?.keyboardType = .numberPad
        }
        
        alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { (_) in
            sender.setTitle("# Success", for: .normal)
        }))
   
        alert.addAction(UIAlertAction(title: "DONE", style: .default, handler: { (action) in
            guard let num = Int(myTextField!.text!) else { return }
            self.hatch.numSuccess = num
            sender.setTitle("\(num) Success", for: .normal)
        }))

        present(alert, animated: true, completion:nil)
        
    }
    
    @IBAction func strandedButtonPressed(_ sender: UIButton) {
        
         var myTextField : UITextField?
         let alert = UIAlertController.init(title: "Enter number of babies that were stranded and needed rescue", message: nil, preferredStyle: .alert)
         alert.addTextField { (textField) in
             myTextField = textField
             myTextField?.delegate = self
             myTextField?.placeholder = "0"
             myTextField?.keyboardType = .numberPad
         }
         
         alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { (_) in
             sender.setTitle("# Stranded", for: .normal)
         }))
    
         alert.addAction(UIAlertAction(title: "DONE", style: .default, handler: { (action) in
             guard let num = Int(myTextField!.text!) else { return }
            self.numStrandedTemp = num
             sender.setTitle("\(num) Stranded", for: .normal)
         }))

             present(alert, animated: true, completion:nil)
    }
    
    @IBAction func deadButtonPressed(_ sender: UIButton) {

     var myTextField : UITextField?
     let alert = UIAlertController.init(title: "Enter number of dead babies found", message: nil, preferredStyle: .alert)
     alert.addTextField { (textField) in
         myTextField = textField
         myTextField?.delegate = self
         myTextField?.placeholder = "0"
         myTextField?.keyboardType = .numberPad
     }
     
     alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { (_) in
         sender.setTitle("# Dead", for: .normal)
     }))

     alert.addAction(UIAlertAction(title: "DONE", style: .default, handler: { (action) in
         guard let num = Int(myTextField!.text!) else { return }
        self.numDeadTemp = num
         sender.setTitle("\(num) Dead", for: .normal)
     }))

         present(alert, animated: true, completion:nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        
        dispatchGroup.enter()
        
        hatch.hatchingExists = hatchingOtherTemp || hatchingSewerTemp || hatchingLightsTemp || hatchingPlantsTemp || hatchingTrashTemp || hatchingNoProblemsTemp
        hatch.noProblems = hatchingNoProblemsTemp
        hatch.trash = hatchingTrashTemp
        hatch.plants = hatchingPlantsTemp
        hatch.lights = hatchingLightsTemp
        hatch.sewer = hatchingSewerTemp
        hatch.other = hatchingOtherTemp
        hatch.numSuccess = numSuccessTemp
        hatch.numStranded = numStrandedTemp
        hatch.numDead = numDeadTemp
        print(hatch)
        
        obs?.hatchingDetails = hatch
        dispatchGroup.leave()
        
        dispatchGroup.notify(queue: .main) {
            self.navigationController?.popViewController(animated: true)

        }
        
    }
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
     
        dispatchGroup.enter()
        print("Saving data")
        hatch.hatchingExists = false
        hatch.noProblems = false
        hatch.trash = false
        hatch.plants = false
        hatch.lights = false
        hatch.sewer = false
        hatch.other = false
        hatch.numSuccess = 0
        hatch.numStranded = 0
        hatch.numDead = 0
        print(hatch)
        obs?.hatchingDetails = hatch
        print("Done saving the following data: \(obs?.hatchingDetails)")
        dispatchGroup.leave()
        
        dispatchGroup.notify(queue: .main) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    
}

