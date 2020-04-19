//
//  FoodItem.swift
//  iFridge
//
//  Created by Shivani Mehan on 2020-04-17.
//  Copyright © 2020 CP469-ShivaniAndJacob. All rights reserved.
//

import Foundation
import UIKit
import os.log

class FoodItem: NSObject, NSCoding {
      var foodName: String!
      var foodImage: UIImage!
      var expiration: String!
 
    struct PropertyKey {
        static let foodName = "foodName"
        static let foodImage = "foodImage"
        static let expiration = "expiration"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(foodName, forKey: PropertyKey.foodName)
        aCoder.encode(foodImage, forKey: PropertyKey.foodImage)
        aCoder.encode(expiration, forKey: PropertyKey.expiration)
    }
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
    guard let nameDecoded = aDecoder.decodeObject(forKey: PropertyKey.foodName) as? String else {
            os_log("Unable to decode the name for a fruit.",log: OSLog.default, type: .debug)
         return nil
        }

        // Because photo is an optional property, just use conditional cast.
        let imageDecoded = (aDecoder.decodeObject(forKey: PropertyKey.foodImage) as? UIImage)!
        let expirationDecoded = (aDecoder.decodeObject(forKey: PropertyKey.expiration) as? String)!
        // Must call designated initializer.
        self.init(foodName: nameDecoded, foodImage: imageDecoded , expiration: expirationDecoded)
        }
    
    init?(foodName: String, foodImage: UIImage, expiration: String) {
        self.foodName = foodName
        self.foodImage = foodImage
        self.expiration = expiration
    } //init?
    
        
    func getExpiration() -> String {
        return self.expiration
    }
    
    func getImage() -> UIImage {
        return self.foodImage
    }
    
    func getFoodName() -> String{
        return self.foodName
    }
    
}

