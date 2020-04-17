//
//  SignInVC.swift
//  Huddle
//
//  Created by Nicholas Wang on 4/16/20.
//  Copyright © 2020 Michael Lin. All rights reserved.
//

import UIKit
import Firebase

class SignInVC: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        self.handleLogin()
    }
    
    func handleLogin() {
        let email = emailField.text!
        let password = passwordField.text!
        
        let auth = Auth.auth()
        auth.signIn(withEmail: email, password: password, completion: { (user, error) in
            guard error == nil else {
                self.displayAlert(title: "Error", message: "Create User Error")
                print(error.debugDescription)
                return
            }
            guard user != nil else {
                self.displayAlert(title: "Error", message: "User Error")
                return
            }
            self.performSegue(withIdentifier: "toHuddles", sender: self)
        })
    }
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
    }
    

}
