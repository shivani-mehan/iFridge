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
        setUp()
    }
    
    func setUp(){
        
        errorLabel.alpha = 0 //hide error label if not in use
        
    }
    
    func isPasswordValid(_ password : String) -> Bool {
        
        //regex for password length being at least 4
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^.{4,}$")
        return passwordTest.evaluate(with: password)
    }
    
    // Check the text fields and validates them
    func validateText() -> String? {
        
        // Check that all fields are filled in
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
            }
            
            
        let trimmedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isPasswordValid(trimmedPassword) == false {
            return "Please make sure your password is at least 4 characters."
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
                    self.displayError("Error making user")
                }
                else {
                    
                    // User was successfully created, add to firestore
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: ["email":email, "uid": result!.user.uid ]) { (error) in
                        
                        if error != nil {
                            // Show error message
                            self.displayError("Error saving user data")
                        }
                    }
                    
                    // Transition to the home view
                    self.transitionToHome()
                }
                
            }
            
            
            
        }
        
        
    }

    func transitionToHome() {
        
//        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
//
//        view.window?.rootViewController = homeViewController
//        view.window?.makeKeyAndVisible()
        print("To do")
        
    }
    
}
