//
//  FridgeCellTableViewCell.swift
//  iFridge
//
//  Created by Shivani Mehan on 2020-04-16.
//  Copyright © 2020 CP469-ShivaniAndJacob. All rights reserved.
//

import UIKit

class FridgeCellTableViewCell: UITableViewCell {

    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var expiration: UILabel!
    
    func setFridgeCell(food: FoodItem){
        foodName.text = food.foodName
        foodImage.image = food.foodImage
        expiration.text = String(food.expiration) + " days"
    }
}
