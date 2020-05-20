//
//  LoginViewController.swift
//  Ghettogram
//
//  Created by Philip Yu on 3/7/19.
//  Copyright © 2019 Philip Yu. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Setup outlet properties
        passwordField.isSecureTextEntry = true
        loginButton.makeRounded(withRadius: 8)
        registerButton.makeRounded(withRadius: 8)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
    }
    
    // MARK: - Private Function Section
    
    @objc private func dismissKeyboard() {
        
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
    }
    
    // MARK: - IBAction Section
    
    @IBAction func onLogIn(_ sender: Any) {
        
        let username = usernameField.text!
        let password = passwordField.text!
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                print("Error: \(String(describing: error!.localizedDescription))")
            }
        }
        
    }
    
    @IBAction func onRegister(_ sender: Any) {
        
        let user = PFUser()
        user.username = usernameField.text
        user.password = passwordField.text
        
        user.signUpInBackground { (success, error) in
            if success {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                print("Error: \(String(describing: error!.localizedDescription))")
            }
        }
        
    }
    
}
