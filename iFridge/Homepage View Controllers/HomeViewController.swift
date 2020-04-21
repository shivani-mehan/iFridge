//
//  HomeViewController.swift
//  iFridge
//
//  Created by Shivani Mehan on 2020-04-16.
//  Copyright © 2020 CP469-ShivaniAndJacob. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseAuth
import FirebaseStorage

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
    
    // MARK: - Setup methods
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sharedFoodCollection = SharingFoodCollection.sharedFoodCollection.foodCollection
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        
        // Request Notification Access
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            print("notification request granted: (\(granted))")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(selectExpiredItem(_:)), name: NSNotification.Name("expiredFoodItem"), object: nil)
        
        // Table View delegate
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        _ = SharingFoodCollection()
        SharingFoodCollection.sharedFoodCollection.foodCollection = FoodItemCollection()
        SharingFoodCollection.sharedFoodCollection.loadFoodCollection()
        sharedFoodCollection = SharingFoodCollection.sharedFoodCollection.foodCollection
        
        // Read objects from database
        loadDatabaseItems()
        
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
    
    func loadDatabaseItems(){
        let dataBase = Firestore.firestore()
        guard let user = Auth.auth().currentUser else { return }
        
        dataBase.collection("users").document("\(user.uid)").collection("fridge").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                    // Change Firestore dates to Dates
                    let inputTimestamp: Timestamp = document.get("foodInputDate") as! Timestamp
                    let inputDate: Date = inputTimestamp.dateValue()
                    
                    let expiryTimestamp: Timestamp = document.get("foodExpiryDate") as! Timestamp
                    let expiryDate: Date = expiryTimestamp.dateValue()
                    
                    // Get image
                    let storageRef = Storage.storage().reference().child("imagesFolder").child("\(user.uid)" + "\(document.get("foodName")!)")
                    
                    storageRef.getData(maxSize: 15 * 1024 * 1024) { data, error in
                        if let error = error {
                            print("An error occurred in downloading the image")
                            print(error.localizedDescription)
                        } else {
                            let image = UIImage(data: data!)
                            
                            let food = FoodItem(foodName: document.get("foodName")! as! String, foodImage: image!, expiration: document.get("foodExpiration")! as! String)
                            
                            food?.changeInputDate(date: inputDate)
                            food?.changeExpiryDate(date: expiryDate)
                            food?.calculateDaysUntilExpiry()
                            
                            self.sharedFoodCollection?.collection.append(food!)
                            self.tableView.reloadData()
                        }
                    }
                    
                }
            }
        }
        
    }
    
    @objc func selectExpiredItem(_ notification: NSNotification){
        if let foodID = notification.userInfo?["food"] as? String {
            var selectRow: Int? = nil
            for food in sharedFoodCollection!.collection {
                if food.foodName == foodID {
                    selectRow = sharedFoodCollection?.collection.firstIndex(of: food)!
                    let path = IndexPath(row: selectRow!, section: 0)
                    self.tableView.reloadData()
                    self.tableView.selectRow(at: path, animated: true, scrollPosition: .top)
                    selectRow = nil
                    break
                }
            }
        }
    }
    
    // MARK: - Actions
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
    
    @IBAction func logoutButton(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToVC1", sender: self)
    }
    
    @IBAction func openFridge(_ sender: Any){
        menuShowing = false
        menu.isHidden = true
    }
    
    
    // MARK:  - Table Methods
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
            // Get the food
            let foodItem = (self.sharedFoodCollection?.collection[indexPath.row])!
            
            //Delete from sharedFoodCollection
            self.sharedFoodCollection?.removeFoodAt(index: indexPath.row)
            
            // Delete from tableview
            self.tableView.deleteRows(at: [indexPath], with: .fade) // Call completion handler to dismiss the action button
            
            // Delete from database
            let dataBase = Firestore.firestore()
            guard let user = Auth.auth().currentUser else { return }
            
            dataBase.collection("users").document("\(user.uid)").collection("fridge").document("\(String(describing: foodItem.foodName!))").delete { (err) in
                if (err != nil){
                    print("Could not delete document")
                }
            }
            
            completionHandler(true)
        }
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipeConfiguration
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Hide menu
        menuShowing = false
        menu.isHidden = true
        
        if (segue.destination is DetailViewController){
            guard let selectedFoodCell = sender as? FridgeCellTableViewCell
                else {
                    fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedFoodCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            sharedFoodCollection?.setCurrentIndex(to: indexPath.row)
        }
        
    }
    
    // MARK:  - Search Bar Methods
    
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
