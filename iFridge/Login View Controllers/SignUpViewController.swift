//
//  SignUpViewController.swift
//  iFridge
//
//  Created by Shivani Mehan on 2020-04-15.
//  Copyright © 2020 CP469-ShivaniAndJacob. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordMatchTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //hide passwords
        passwordTextField.isSecureTextEntry = true
        passwordMatchTextField.isSecureTextEntry = true
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
    
    
    func validateText() -> String? {
        
        // Check that all fields are filled in
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordMatchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        
        //MARK: - Need to fix password validation. Password automatically needs to be > 6 length. Having trouble comparing them
        if passwordTextField.text!.count < 6 {
            return "password must be at least 6 characters"
        }
        
        if passwordMatchTextField.text != passwordTextField.text {
            return "Passwords do not match"
        }
        
        return nil
    }
    
    func displayError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    
    @IBAction func signInPressed(_ sender: Any) {
        //validate text
        let error = validateText()
        
        //show error via label
        if error != nil {
            displayError(error!)
        }
            // no errors, continue to create user w/ firebase auth
        else {
            
            // Clean the text
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Create user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                // Check for errors
                if err != nil {
                    
                    // Display error
                    self.displayError("Error: User cannot be made.")
                    let alert = UIAlertController(title: "Something went wrong", message: "Please try again.", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    
                    self.present(alert, animated: true)
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    
                }
                else {
                    // User was successfully created, add to firestore
                    let db = Firestore.firestore()
                    
                    //MARK: - Storing passwords for testing. DELETE WHEN DONE
                    db.collection("users").document("\(result!.user.uid)").setData(["email":email,"password":password, "uid": result!.user.uid ]) { (err) in
                        if (err != nil) {
                            print(err!.localizedDescription)
                        }
                    }
                    
                    // Transition to the home view
                    let controller = (self.storyboard?.instantiateViewController(withIdentifier: "iFridgeHome"))!
                    self.navigationController!.pushViewController(controller, animated: true)
                }
                
            }
            
        }
        
        
    }
    
    
    
}
