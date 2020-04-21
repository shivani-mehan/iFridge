//
//  LoginViewController.swift
//  iFridge
//
//  Created by Shivani Mehan on 2020-04-15.
//  Copyright © 2020 CP469-ShivaniAndJacob. All rights reserved.
//

import UIKit
import FirebaseAuth


class LoginViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()

    }
    func setUp(){
        errorLabel.alpha = 0 //hide error label if not in use
    }
    
    
    
    //dismiss keyboard when touching outside textfields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }

    // MARK: - Navigation

    @IBAction func loginPressed(_ sender: Any) {
        
        
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Login w/ auth
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                // Couldn't sign in
                self.errorLabel.text = "Invalid. Try again"
                self.errorLabel.alpha = 1
            }
            else {
                //display alert and move to home
                let index = email.firstIndex(of: "@")
                let name = email.prefix(upTo: index!).uppercased()
                
                let alert = UIAlertController(title: "WELCOME BACK \(name)", message: "Have a nice day!", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "You too!", style: .default, handler: self.someHandler))
                alert.addAction(UIAlertAction(title: "You as well!", style: .default, handler: self.someHandler))

                self.present(alert, animated: true)
                
            }
        }
    }
    
    func someHandler(alert: UIAlertAction!) {
        let controller = (self.storyboard?.instantiateViewController(withIdentifier: "iFridgeHome"))!
        self.navigationController!.pushViewController(controller, animated: true)
    }
}
