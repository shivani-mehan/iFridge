//
//  DetailViewController.swift
//  iFridge
//
//  Created by Shivani Mehan on 2020-04-18.
//  Copyright © 2020 CP469-ShivaniAndJacob. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var expiration: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var expiryDate: UILabel!
    
    var sharedFoodCollection : FoodItemCollection?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sharedFoodCollection = SharingFoodCollection.sharedFoodCollection.foodCollection
        
        let food = sharedFoodCollection?.currentFood()
        
        let myFormatter = DateFormatter()
        myFormatter.dateStyle = .short
        expiryDate.text = myFormatter.string(from: food!.getExpiryDate())
        
        let expired = food!.checkIfExpired()
        if (expired){
            expiration.text = "Expired!"
        } else {
            expiration.text = String(food!.expiration) + " days"
        }
        
        foodName.text = String(food!.getFoodName())
        foodImage.image =  food!.getImage()
    }
    
}
