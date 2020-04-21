//
//  FoodItem.swift
//  iFridge
//
//  Created by Shivani Mehan on 2020-04-17.
//  Copyright © 2020 CP469-ShivaniAndJacob. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit
import os.log

class FoodItem: NSObject, NSCoding {
      var foodName: String!
      var foodImage: UIImage!
      var expiration: String!
      var inputDate: Date!
      var expiryDate: Date!
      var isExpired = false
 
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
        
        let today = Date()
        self.inputDate = today
        
        let modifiedDate = Calendar.current.date(byAdding: .day, value: Int(expiration)!, to: today)!
        self.expiryDate = modifiedDate
    } //init?
    
    // MARK: - Helper Functions
        
    func getExpiryDate() -> Date {
        return self.expiryDate
    }
    
    func getInputDate() -> Date {
        return self.inputDate
    }
    
    func getExpiration() -> String {
        return self.expiration
    }
    
    func getImage() -> UIImage {
        return self.foodImage
    }
    
    func getFoodName() -> String{
        return self.foodName
    }
    
    func checkIfExpired() -> Bool {
        let comparison = Calendar.current.compare(self.inputDate, to: self.expiryDate, toGranularity: .day)
        
        // Make notification for when item is expired (only once)
        if (comparison == .orderedSame && isExpired == false){
           isExpired = true
           setupNotification()
        }
        
        return (comparison == .orderedSame)
    }
    
    func setupNotification() {
        let content = UNMutableNotificationContent()
        content.title = "\(String(describing: self.foodName!)) has expired!"
        content.body = "Click this notification to be taken to the item."
        content.sound = UNNotificationSound.default
        content.userInfo = ["food": self.foodName!] // You can retrieve this when displaying notification
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: "TestIdentifier", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func calculateDaysUntilExpiry() {
        let date1 = Calendar.current.startOfDay(for: self.inputDate)
        let date2 = Calendar.current.startOfDay(for: self.expiryDate)
        
        let daysUntilExpiry = Calendar.current.dateComponents([.day], from: date1, to: date2)
        self.expiration = String(daysUntilExpiry.day!)
    }
    
    func changeInputDate(date: Date){
        self.inputDate = date
    }
    
    func changeExpiryDate(date: Date){
        self.expiryDate = date
    }
}

