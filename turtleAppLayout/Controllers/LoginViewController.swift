//
//  LoginViewController.swift
//  turtleAppLayout
//
//  Created by Olivia James on 9/3/20.
//  Copyright © 2020 Sebastien James. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {

    let defaults = UserDefaults.standard

    @IBOutlet weak var userIDTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func didDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tortues Tahiti Patrol"
        userIDTextField.text = defaults.value(forKey: "userID") as? String
        
    }
    
    
    @IBAction func loginPressed(_ sender: Any) {
        defaults.set(userIDTextField.text ?? "", forKey: "userID")
        if defaults.value(forKey: "userID") as? String != "" {
              performSegue(withIdentifier: "LoginToHome", sender: self)
          } else {
              let alert = UIAlertController(title: "ENTER A USER ID FIRST", message: "", preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "DISMISS", style: .cancel, handler: nil))
              present(alert, animated: true)
              alert.view.tintColor = UIColor.black
          }
        
//        MOVE ALL THIS TO UPLOAD FUNCTION
//        if let userID = userIDTextField.text, let password = passwordTextField.text {
//            Auth.auth().signIn(withCustomToken: userID) { authResult, error) in
//                if let e = error {
//                    print(e.localizedDescription)  // Create a lable or popup to display this error to the user
//                } else{
//                    self.performSegue(withIdentifier: LoginToHome, sender: self)
//                }
//            }
//
//        }
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
