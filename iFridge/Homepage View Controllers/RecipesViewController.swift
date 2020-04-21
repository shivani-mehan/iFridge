//
//  RecipesViewController.swift
//  iFridge
//
//  Created by Shivani Mehan on 2020-04-21.
//  Copyright © 2020 CP469-ShivaniAndJacob. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RecipeTableViewCell: UITableViewCell {
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeLabel: UILabel!
    
    func setRecipe(recipe: Recipes){
        recipeLabel.text = recipe.title
        
        // Load the cell image
        let url = URL(string: recipe.image)!
        var image: UIImage?
        
        //All network operations has to run on different thread(not on main thread).
        DispatchQueue.global(qos: .userInitiated).async {
            let imageData = NSData(contentsOf: url)
            //All UI operations has to run on main thread.
            DispatchQueue.main.async {
                if imageData != nil {
                    image = UIImage(data: imageData! as Data)
                    self.recipeImage.image = image
                } else {
                    image = nil
                }
            }
        }
    }
    
}


struct Recipes: Decodable {
    let id: Int
    let title: String
    let image: String
}

struct RecipeURL: Decodable{
    var sourceUrl: String
}

class RecipesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var recipes = [Recipes]()
    var firstItem = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Table view delegate
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Get the recipes
        getRecipes()
    }
    
    func getRecipes() {
        let headers = [
            "x-rapidapi-host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com",
            "x-rapidapi-key": "37f443739fmsh8f774c535d2f7dap1ff255jsnbd2563bba998"
        ]
        
        var foodString = ""
        
        let dataBase = Firestore.firestore()
        guard let user = Auth.auth().currentUser else { return }
        
        dataBase.collection("users").document("\(user.uid)").collection("fridge").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let name = document.get("foodName")! as! String
                    let nameLowerCased = name.lowercased()
                    
                    if (self.firstItem){
                        foodString.append(nameLowerCased)
                        self.firstItem = false
                    } else {
                        foodString.append("%252C" + nameLowerCased)
                    }
                }
                
                let request = NSMutableURLRequest(url: NSURL(string: "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/findByIngredients?ranking=1&ignorePantry=true&ingredients=" + foodString)! as URL,cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
                
                request.httpMethod = "GET"
                request.allHTTPHeaderFields = headers
                
                let session = URLSession.shared
                let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                    DispatchQueue.main.async {
                        if (error != nil) {
                            print(error!)
                        }
                        
                        guard let data = data else {
                            return
                        }
                        
                        do {
                            let decoder = JSONDecoder()
                            self.recipes = try decoder.decode([Recipes].self, from: data)
                            self.tableView.reloadData()
                        } catch {
                            print("Error from catch")
                        }
                    }
                    
                })
                dataTask.resume()
            }
        }
    }
    
    // MARK:  - Table Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell") as! RecipeTableViewCell
        let recipe = recipes[indexPath.row]
        cell.setRecipe(recipe: recipe)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        print("selected cell \(indexPath.row)")
        
        let recipe = recipes[indexPath.row]
        let recipeID = String(recipe.id)
        
        let headers = [
            "x-rapidapi-host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com",
            "x-rapidapi-key": "37f443739fmsh8f774c535d2f7dap1ff255jsnbd2563bba998"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/" + recipeID + "/information")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            DispatchQueue.main.async {
                
                
                if (error != nil) {
                    print(error!)
                }
                guard let data = data else {
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let recipeURL = try decoder.decode(RecipeURL.self, from: data)
                    
                    if let url = URL(string: recipeURL.sourceUrl) {
                        UIApplication.shared.open(url)
                    }
                } catch {
                    print("Error from catch")
                }
                
            }
        })
        
        dataTask.resume()
        
    }
}
