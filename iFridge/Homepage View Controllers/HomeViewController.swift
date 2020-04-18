//
//  HomeViewController.swift
//  iFridge
//
//  Created by Shivani Mehan on 2020-04-16.
//  Copyright © 2020 CP469-ShivaniAndJacob. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    // Table and Search Bar Outlets
    @IBOutlet weak var tableView: UITableView!
    
    var resultSearchController = UISearchController()
    
    // Arrays
    var sharedFoodCollection : FoodItemCollection? // this will be the unique FoodCollection we want to work with
    var food: [FoodItem] = []
    var filteredTableData = [FoodItem]()
    
    // Menu Outlets and Variables
    @IBOutlet weak var menuLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuBackgroundImageLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var menu: UIView!
    var menuShowing = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sharedFoodCollection = SharingFoodCollection.sharedFoodCollection.foodCollection
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Table View delegate
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        _ = SharingFoodCollection()
        SharingFoodCollection.sharedFoodCollection.foodCollection = FoodItemCollection()
        SharingFoodCollection.sharedFoodCollection.loadFoodCollection()
        sharedFoodCollection = SharingFoodCollection.sharedFoodCollection.foodCollection
        
        // Search Bar Set Up
        self.resultSearchController = ({
            
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.searchBar.sizeToFit()
            controller.searchBar.prompt = "Search Your Fridge!"
            controller.searchBar.placeholder = "Search for foods or by expiration date"
            
            self.tableView.tableHeaderView = controller.searchBar
            return controller
            
        })()
    }
    
    // MARK: * - Menu Function
    @IBAction func openMenu(_ sender: Any) {
        if (menuShowing){
            menuLeadingConstraint.constant = -205
            menuBackgroundImageLeadingConstraint.constant = -205
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            })
        } else {
            menu.isHidden = false
            menuLeadingConstraint.constant = 0
            menuBackgroundImageLeadingConstraint.constant = 0
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            })
        }
        menuShowing = !menuShowing
    }
    
    // MARK: * - Logout button
    @IBAction func logoutButton(_ sender: Any) {
        performSegue(withIdentifier: "unwindToStart", sender: self)
    }
    
    
    // MARK: * - Table Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.resultSearchController.isActive) {
            return self.filteredTableData.count
        } else {
            return (sharedFoodCollection?.collection.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fridgeCell") as! FridgeCellTableViewCell
        
        if (self.resultSearchController.isActive) {
            let foodItem = filteredTableData[indexPath.row]
            cell.setFridgeCell(food: foodItem)
            
            return cell
        } else {
            let foodItem = (sharedFoodCollection?.collection[indexPath.row])!
            cell.setFridgeCell(food: foodItem)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {                  (action, sourceView, completionHandler) in
            //Delete
            self.sharedFoodCollection?.removeFoodAt(index: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade) // Call completion handler to dismiss the action button
            completionHandler(true)          }
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipeConfiguration
    }
    
    // MARK: * - Search Bar Methods
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredTableData.removeAll(keepingCapacity: false)
        let searchTerm = searchController.searchBar.text!
        
        let array = sharedFoodCollection?.collection.filter { food in
            return food.foodName.contains(searchTerm) ||
                food.expiration.contains(searchTerm)
        }
        
        filteredTableData = (array)!
        self.tableView.reloadData()
    }
}
