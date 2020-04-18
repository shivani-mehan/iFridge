//
//  AddFoodItemViewController.swift
//  iFridge
//
//  Created by Shivani Mehan on 2020-04-17.
//  Copyright © 2020 CP469-ShivaniAndJacob. All rights reserved.
//

import UIKit

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
    
    @IBAction func saveButton(_ sender: Any) {
        if (foodNameTextField.text == nil || expirationTextField.text == nil || foodImage.image == nil){
            print("No picture or text")
        } else {
            let food = FoodItem(foodName: foodNameTextField.text!, foodImage: foodImage.image!, expiration: expirationTextField.text!)
            sharedFoodCollection?.collection.append(food!)
            
            let alert = UIAlertController(title: "Add Food", message: "Saved!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            
            foodNameTextField.text = ""
            expirationTextField.text = ""
            foodImage.image = UIImage(named: "arrow.up.doc")
        }
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
