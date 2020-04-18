//
//  SharingFoodCollection.swift
//  iFridge
//
//  Created by Shivani Mehan on 2020-04-18.
//  Copyright © 2020 CP469-ShivaniAndJacob. All rights reserved.
//

import Foundation

class SharingFoodCollection {
    static let sharedFoodCollection = SharingFoodCollection()
    let fileName = "iFridgeFood.archive"
    private let rootKey = "rootKey"
    var foodCollection : FoodItemCollection?
    
    
    func dataFilePath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentDirectory,
            FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory = paths[0] as NSString
        return documentsDirectory.appendingPathComponent(fileName) as String
    }
    
    func loadFoodCollection(){
        print("load Food Collection ...starting")
        let filePath = self.dataFilePath()
        if (FileManager.default.fileExists(atPath: filePath)) {
            let data = NSMutableData(contentsOfFile: filePath)!
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data as Data)
            SharingFoodCollection.sharedFoodCollection.foodCollection =
                unarchiver.decodeObject(forKey: rootKey) as? FoodItemCollection
            unarchiver.finishDecoding()
        }
    }
    
    func saveFruitCollection(){
        let filePath = self.dataFilePath()
        print("saving the data")
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        
        archiver.encode(SharingFoodCollection.sharedFoodCollection.foodCollection, forKey: rootKey)
        archiver.finishEncoding()
        data.write(toFile: filePath, atomically: true)
    }
    
} //Class
