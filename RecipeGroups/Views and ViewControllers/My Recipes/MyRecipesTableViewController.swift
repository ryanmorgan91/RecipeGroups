//
//  MyRecipesTableViewController.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/17/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import UIKit

class MyRecipesTableViewController: UITableViewController {
    
    let interactor = Interactor()
    var recipes: [Recipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: RecipeController.recipeDataUpdatedNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupView()
        updateUI()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return recipes.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! MyRecipesTableViewCell
        
        /* Comment the following if using sample recipes */
        configure(cell, forItemAt: indexPath)
        
        /* comment the following to remove sample images */
        
//        let recipe = recipes[indexPath.section]
//        cell.recipeLabel.text = recipe.name
//        cell.recipeImage.image = recipe.image
        
        return cell
    }
    
    func setupView() {
        tableView.separatorStyle = .none
        tableView.rowHeight = 200
        navigationItem.leftBarButtonItem?.tintColor = CustomStyles.shared.customPink
    }
    
    @objc func updateUI() {
        
        self.recipes = RecipeController.shared.savedRecipes
        self.recipes += RecipeController.shared.likedRecipes
        
        self.tableView.reloadData()
    }
    
    func configure(_ cell: MyRecipesTableViewCell, forItemAt indexPath: IndexPath) {
        let recipe = recipes[indexPath.section]
        cell.recipeLabel.text = recipe.name
        if recipe.image != nil {
            cell.recipeImage.image = recipe.image
            cell.setNeedsLayout()
        } else {
            RecipeController.shared.fetchImage(url: recipe.imageURL!) { (image) in
                guard let image = image else { return }
                DispatchQueue.main.async {
                    if let currentIndexPath = self.tableView.indexPath(for: cell),
                        currentIndexPath != indexPath {
                        return
                    }
                    cell.recipeImage.image = image
                    recipe.image = image
                    cell.setNeedsLayout()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.layer.masksToBounds = true
        
    }
    
    /*
    * If the segue is for the MenuViewController, set up the necessary properties and delegation patterns,
    *    otherwise, pass the selected recipe to RecipeDetailViewController
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? MenuViewController {
            destinationViewController.transitioningDelegate = self
            destinationViewController.interactor = interactor
            destinationViewController.currentViewController = self
            destinationViewController.delegate = self
        } else if segue.identifier == "SegueFromMyRecipesToRecipeDetailView" {
            let destinationViewController = segue.destination as! RecipeDetailViewController
            let index = tableView.indexPathForSelectedRow!.section
            destinationViewController.recipe = self.recipes[index]
        }
    }
}

// Either log the user out (if user tapped "logout"), or push the corresponding view controller onto the navigation stack
extension MyRecipesTableViewController: SideMenuDelegate {
    func userTapped(menuButton: String) {
        switch menuButton {
        case "Logout":
            if !UserController.shared.userIsLoggedIn {
                if let viewConstroller = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                    self.navigationController?.pushViewController(viewConstroller, animated: true)
                }
            } else {
                UserController.shared.logoutUser()
            }
        case "My Groups":
            if let viewController = storyboard?.instantiateViewController(withIdentifier: "MyGroupsTableViewController") as? MyGroupsTableViewController {
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        case "Recipes":
            self.navigationController?.popToRootViewController(animated: true)
        case "Create Account":
            if let viewController = storyboard?.instantiateViewController(withIdentifier: "CreateAccountViewController") as? CreateAccountViewController {
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        default:
            break
        }
    }
}

// Implement the side menu transitioning delegate patterns
extension MyRecipesTableViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentMenuAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissMenuAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}
