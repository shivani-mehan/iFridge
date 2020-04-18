//
//  FoodItemCollection.swift
//  iFridge
//
//  Created by Shivani Mehan on 2020-04-18.
//  Copyright © 2020 CP469-ShivaniAndJacob. All rights reserved.
//

import Foundation
import UIKit

class FoodItemCollection: NSObject, NSCoding {

    var collection = [FoodItem]() // a collection is an array of fruits
    var current:Int = 0 // the current fruit in the collection (to be shown in the scene)
    let collectionKey = "collectionKey"
    let currentKey = "currentKey"
    // MARK: - NSCoding methods
    override init(){
        super.init()
        setup()
    }
    
    // Read database and populate the collection?
    func setup(){

    }
    
    func encode(with acoder: NSCoder) {
        acoder.encode(collection, forKey: collectionKey)
        acoder.encode(current, forKey: currentKey)
    }

    required convenience init?(coder decoder: NSCoder) {
        self.init()
        collection = (decoder.decodeObject(forKey: collectionKey) as? [FoodItem])!
        current = (decoder.decodeInteger(forKey: currentKey))
    }
    
    func getExpiration() -> String {
        let food = self.collection[self.current]
        return food.expiration
    }
    
    func currentFruit() -> FoodItem {
        let food = self.collection[self.current]
        return food
    }
    
    func setCurrentIndex(to index: Int){
        self.current = index
    }
    
    func getCurrentIndex() -> Int {
        return self.current
    }
    
    func addFruit(food: FoodItem) {
        self.collection.append(food)
    }
    
    func deleteFruit(food : FoodItem) {
        if let index = self.collection.firstIndex(of: food) {
            self.collection.remove(at: index)
        }
    }
    
    func removeFoodAt(index: Int){
        self.collection.remove(at: index)
    }
}
    
