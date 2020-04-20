//
//  FoodItemCollection.swift
//  iFridge
//
//  Created by Shivani Mehan on 2020-04-18.
//  Copyright © 2020 CP469-ShivaniAndJacob. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

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
    
    // Read database and populate the collection? **
    func setup(){
        // Read existing food items into array
        let dataBase = Firestore.firestore()
        guard let user = Auth.auth().currentUser else { return }
        
        dataBase.collection("users").document("\(user.uid)").collection("fridge").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    print(document.get("foodName")!)
//                    let date1 = document.get("foodInputDate")!)
//                    let date = postTimestamp.dateValue()

                }
            }
        }
        
        // Sample food
        let food = FoodItem(foodName: "Bananas", foodImage: UIImage(named: "bananas")!, expiration: "3")
        self.collection.append(food!)
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
    
    func currentFood() -> FoodItem {
        let food = self.collection[self.current]
        return food
    }
    
    func setCurrentIndex(to index: Int){
        self.current = index
    }
    
    func getCurrentIndex() -> Int {
        return self.current
    }
    
    func addFood(food: FoodItem) {
        self.collection.append(food)
    }
    
    func deleteFood(food : FoodItem) {
        if let index = self.collection.firstIndex(of: food) {
            self.collection.remove(at: index)
        }
    }
    
    func removeFoodAt(index: Int){
        self.collection.remove(at: index)
    }
    
    
    func getFoodImage() -> UIImage {
        return self.collection[self.current].foodImage
    }
    
    func getFoodName() -> String {
        return self.collection[self.current].foodName
    }
    
}

