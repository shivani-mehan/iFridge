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


        // Do any additional setup after loading the view.
    }
    func setUp(){
        errorLabel.alpha = 0 //hide error label if not in use
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func loginPressed(_ sender: Any) {
        
        
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Login w/ auth
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                // Couldn't sign in
                self.errorLabel.text = error!.localizedDescription
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
        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "iFridgeHome") as? HomeViewController

        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
    }
}
