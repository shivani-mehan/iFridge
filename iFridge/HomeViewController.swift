//
//  HomeViewController.swift
//  iFridge
//
//  Created by Shivani Mehan on 2020-04-16.
//  Copyright © 2020 CP469-ShivaniAndJacob. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Table Outlet and Variables
    @IBOutlet weak var tableView: UITableView!
    
    // Array to store food items
    var food: [FoodItem] = []
    
    // Menu Outlets and Variables
    @IBOutlet weak var menuLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuBackgroundImageLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var menu: UIView!
    var menuShowing = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Populate food array with items
        populateArray()
        
        // Table View delegate
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func populateArray(){
        let foodItem = FoodItem(foodName: "Bananas", foodImage: UIImage(named:"bananas")!, expiration: 3)
        food.append(foodItem)
    }
    
    // MARK: Menu Function
    @IBAction func openMenu(_ sender: Any) {
        if (menuShowing){
            tableView.isHidden = false
            menuLeadingConstraint.constant = -205
            menuBackgroundImageLeadingConstraint.constant = -205
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            })
        } else {
            tableView.isHidden = true
            menu.isHidden = false
            menuLeadingConstraint.constant = 0
            menuBackgroundImageLeadingConstraint.constant = 0
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            })
        }
        menuShowing = !menuShowing
    }
    
    // MARK: Logout button
    @IBAction func logoutButton(_ sender: Any) {
        performSegue(withIdentifier: "unwindToStart", sender: self)
    }
    
    
    // MARK: Table Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return food.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let foodItem = food[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "fridgeCell") as! FridgeCellTableViewCell
        cell.setFridgeCell(food: foodItem)
        
        return cell
    }
}
