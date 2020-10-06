//
//  LoginViewController.swift
//  turtleAppLayout
//
//  Created by Olivia James on 9/3/20.
//  Copyright © 2020 Sebastien James. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {

    
    let defaults = UserDefaults.standard

    @IBOutlet weak var userIDTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func didDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        userIDTextField.text = defaults.value(forKey: "userID") as? String
        let email = defaults.value(forKey: "email") as? String ?? ""
        let password = defaults.value(forKey: "password") as? String ?? ""
        login()


    }
    
    func login() {
        let email = defaults.value(forKey: "email") as? String ?? ""
        let password = defaults.value(forKey: "password") as? String ?? ""
        if email != "" && password != "" {
            print("gud")
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                if let error = error {
                    print(error)
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        } else {
            var emailTextField = UITextField()
            var passwordTextField = UITextField()
            
            let alert = UIAlertController(title: "Create an account", message: "", preferredStyle: .alert)
            
            alert.addTextField { (textField) in
                emailTextField = textField
                emailTextField.delegate = self
                emailTextField.placeholder = "email"
            }
            
            alert.addTextField { (textField) in
                passwordTextField = textField
                passwordTextField.delegate = self
                passwordTextField.placeholder = "password"
            }
            
            alert.addAction(UIAlertAction(title: "Don", style: .default, handler: { (action) in
                guard let email = emailTextField.text else { return }
                guard let password = passwordTextField.text else { return }
                self.defaults.set(emailTextField.text ?? "", forKey: "email")
                self.defaults.set(passwordTextField.text ?? "", forKey: "password")
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_) in
                
            }))
            
            present(alert, animated: true)
        }
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
