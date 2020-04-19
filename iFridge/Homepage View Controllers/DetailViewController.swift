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
    
    var sharedFoodCollection : FoodItemCollection?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sharedFoodCollection = SharingFoodCollection.sharedFoodCollection.foodCollection
        
        let food = sharedFoodCollection?.currentFood()
        
        foodName.text = String(food!.getFoodName())
        expiration.text = String(food!.getExpiration())
        foodImage.image =  food!.getImage()
    }
    
}
