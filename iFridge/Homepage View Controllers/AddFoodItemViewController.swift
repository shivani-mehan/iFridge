//
//  AddFoodItemViewController.swift
//  iFridge
//
//  Created by Shivani Mehan on 2020-04-17.
//  Copyright © 2020 CP469-ShivaniAndJacob. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class AddFoodItemViewController: UIViewController, UIImagePickerControllerDelegate, UITextFieldDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var foodNameTextField: UITextField!
    @IBOutlet weak var expirationTextField: UITextField!
    @IBOutlet weak var foodImage: UIImageView!
    
    var food: FoodItem?
    var sharedFoodCollection : FoodItemCollection?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sharedFoodCollection = SharingFoodCollection.sharedFoodCollection.foodCollection
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodImage.isUserInteractionEnabled = true
        foodNameTextField.delegate = self
        expirationTextField.delegate = self
    }
    
    
    
 

    
    func validateText() -> String? {
        
        // Check that all fields are filled in
        if foodNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || expirationTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || foodImage.image == nil{
            
            return "Please fill in all fields."
        }
        

    
        let numcheck = Int(expirationTextField.text!)
        //check expiration date
        if numcheck == nil || numcheck! < 0 {
            return "Please enter an expiry date > 0"
        }
        
        return nil
    }
    
    
    func displayError(_ message:String) {
        
//        errorLabel.text = message
//        errorLabel.alpha = 1
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        
        
        //validate text
        let error = validateText()
        
        if error != nil {
            displayError(error!)
        self.displayError(error!)
        let alert = UIAlertController(title: "Something went wrong", message: "Please try again.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        
        self.present(alert, animated: true)
        self.expirationTextField.text = ""
        self.foodNameTextField.text = ""
            
            
        }
        else{
        
 
            // Create food and add to shared collection
            let food = FoodItem(foodName: foodNameTextField.text!, foodImage: foodImage.image!, expiration: expirationTextField.text!)
            sharedFoodCollection?.collection.append(food!)
            
            // Add food to database
            let dataBase = Firestore.firestore()
            guard let user = Auth.auth().currentUser else { return }
            
            // Load image
            guard let image = foodImage.image,
                let data = image.jpegData(compressionQuality: 1.0) else {
                    print("Error converting image to data")
                    return
            }
            
            let imageReference = Storage.storage().reference()
                .child("imagesFolder")
                .child("\(user.uid)" + "\(String(describing: food!.foodName!))")
            
            imageReference.putData(data, metadata: nil) { (metadata, err) in
                if err != nil {
                    print("Error saving image to storage")
                }
                
                imageReference.downloadURL { (url, err) in
                    if err != nil {
                        print("Error downloading image url")
                    }
                    
                    guard let url = url else {
                        print("Can't load image url")
                        return
                    }
                    
                    let urlString = url.absoluteString
                    
                    dataBase.collection("users").document("\(user.uid)").collection("fridge").document("\(String(describing: food!.foodName!))").setData(["foodName": food!.foodName!, "foodImage":urlString ,"foodExpiration":food!.expiration!, "foodInputDate":food!.inputDate!, "foodExpiryDate":food!.expiryDate!]) { (err) in
                        if (err != nil) {
                            print(err!.localizedDescription)
                        }
                    }
                    
                    
                }
            }
            
            // Send alert that food has been saved
            let alert = UIAlertController(title: "Add Food", message: "Saved!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: someHandler(alert:)))
            self.present(alert, animated: true)
            
            // Reset values
            foodNameTextField.text = ""
            expirationTextField.text = ""
            foodImage.image = UIImage(systemName: "arrow.up.doc")
            
            //move back to homeview
            
            
            
        }
    }
    
    func someHandler(alert: UIAlertAction!) {
        let controller = (self.storyboard?.instantiateViewController(withIdentifier: "iFridgeHome"))!
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    @IBAction func tappedImage(_ sender: UITapGestureRecognizer) {
        let pickImage = UIImagePickerController()
        pickImage.sourceType = .photoLibrary
        pickImage.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        present(pickImage, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        textField.becomeFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text ?? ""
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]){
        
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        guard let selectedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage else{ return }
        
        info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)]
        
        foodImage.image = selectedImage
        
        dismiss(animated: true, completion: nil)
    }
    
    
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    
    func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
