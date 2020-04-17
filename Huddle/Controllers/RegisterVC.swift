//
//  RegisterVC.swift
//  Huddle
//
//  Created by Nicholas Wang on 4/16/20.
//  Copyright © 2020 Michael Lin. All rights reserved.
//

import UIKit
import Firebase

class RegisterVC: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerBtn(_ sender: Any) {
        self.handleRegister()
    }
    
    func handleRegister() {
        let name = nameField.text!
        let email = emailField.text!
        let password = passwordField.text!
        let passwordConfirm = confirmField.text!
        
        if password != passwordConfirm {
            self.displayAlert(title: "Error", message: "Passwords do not match")
        }
        
        let auth = Auth.auth()      // authentication object
        
        // 1. Create User
        auth.createUser(withEmail: email, password: password) { (user, error) in
            guard error == nil else {
                self.displayAlert(title: "Error", message: "Create User Error")
                print(error.debugDescription)
                return
            }
            guard user != nil else {
                self.displayAlert(title: "Error", message: "User Error")
                return
            }
            
            // 2. Enter new node into database
            let db = Database.database().reference()
            let usersNode = db.child("Huddle_user")
            guard let newUserId = usersNode.childByAutoId().key else {
                print("Hello")
                return
            }
            let userNode = usersNode.child(newUserId)
            userNode.updateChildValues(["email": email, "name": name])
            
            // 3. Segue to Login
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
    }

}
