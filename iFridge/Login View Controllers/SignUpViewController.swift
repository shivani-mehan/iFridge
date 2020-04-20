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
    
      //MARK: - Password regex
//    func isPasswordValid(_ password : String) -> Bool {
//
//        //regex for password length being at least 4
//        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^.{4,}$")
//        return passwordTest.evaluate(with: password)
//    }
    
    // Check the text fields and validates them
    func validateText() -> String? {
        
        // Check that all fields are filled in
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            
            return "Please fill in all fields."
        }
        
        
        //MARK: - Need to fix password validation. Password automatically needs to be > 6 length. Having trouble comparing them
        if passwordTextField.text!.count < 6 {
            return "password must be at least 6 characters"
        }
        
//        if passwordMatchTextField != passwordTextField{
//            return "Passwords do not match"
//        }
        
        
            
//        let trimmedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//
//        if isPasswordValid(trimmedPassword) == false {
//            return "Please make sure your password is at least 4 characters."
//        }
//
            
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
                    self.displayError("User cannot be made error")
                    let alert = UIAlertController(title: "Something went wrong", message: "It's recommended you bring your towel before continuing.", preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

                    self.present(alert, animated: true)
                }
                else {
                    
                    // User was successfully created, add to firestore
                    let db = Firestore.firestore()
                    
                    //MARK: - Storing passwords for testing. DELETE WHEN DONE
                    db.collection("users").addDocument(data: ["email":email,"password":password, "uid": result!.user.uid ]) { (error) in
                        
                        if error != nil {
                            // Show error message
                            self.displayError("Error saving user data")
                        }
                    }
                    
                    // Transition to the home view
                    let homeViewController = self.storyboard?.instantiateViewController(identifier: "iFridgeHome") as? HomeViewController
            
                    self.view.window?.rootViewController = homeViewController
                    self.view.window?.makeKeyAndVisible()
                    
                        //MARK: - alert for testing
//                    let alert = UIAlertController(title: "GREAT SUCCESS!", message: "It's recommended you bring your towel before continuing.", preferredStyle: .alert)
//
//                    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
//                    alert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: nil))
//
//                    self.present(alert, animated: true)
                    
                }
                
            }
            
            
            
        }
        
        
    }

    func transitionToHome() {
        
//        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
//
//        view.window?.rootViewController = homeViewController
//        view.window?.makeKeyAndVisible()
        print("To do---------")
        
    }
    
}
