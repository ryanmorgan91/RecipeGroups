//
//  RecipeTableViewController.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/12/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import UIKit

class RecipeTableViewController: UITableViewController {

    let interactor = Interactor()
    var recipes: [Recipe] = []
    var alreadyProvidedLoginSuggestion = false
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeTableViewCell
        
        /* Comment the following if using samples */
        configure(cell, forItemAt: indexPath)
        
        /* comment the following to remove sample images
 
        let recipe = recipes[indexPath.section]
        cell.recipeLabel.text = recipe.name
        cell.recipeImage.image = recipe.image

         */
 
        return cell
    }
    
    func setupView() {
        tableView.separatorStyle = .none
        tableView.rowHeight = 200
        navigationItem.leftBarButtonItem?.tintColor = CustomStyles.shared.customPink
    }
    
    @objc func updateUI() {
        self.recipes = RecipeController.shared.recipes
        self.tableView.reloadData()
    }
    
    func configure(_ cell: RecipeTableViewCell, forItemAt indexPath: IndexPath) {
        let recipe = recipes[indexPath.section]
        cell.recipeLabel.text = recipe.name
        if recipe.image != nil {
            cell.recipeImage.image = recipe.image
            cell.setNeedsLayout()
        } else if recipe.imageURL != nil {
            RecipeController.shared.fetchImage(url: recipe.imageURL!) { (image) in
                guard let image = image else { return }
                DispatchQueue.main.async {
                    if let currentIndexPath = self.tableView.indexPath(for: cell),
                        currentIndexPath != indexPath {
                        return
                    }
                    cell.recipeImage.image = image
                    cell.setNeedsLayout()
                    recipe.image = image
                }
            }
        } else {
            print("Error, no recipe image")
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.contentView.layer.masksToBounds = true
    }
    
    @IBAction func menuButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "openMenu", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? MenuViewController {
            destinationViewController.transitioningDelegate = self
            destinationViewController.interactor = interactor
            destinationViewController.currentViewController = self
            destinationViewController.delegate = self
        } else if segue.identifier == "SegueFromRecipesToRecipeDetail" {
            let destinationViewController = segue.destination as! RecipeDetailViewController
            let index = tableView.indexPathForSelectedRow!.section
            destinationViewController.recipe = self.recipes[index]
        }
    }
    
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        if !UserController.shared.userIsLoggedIn && !alreadyProvidedLoginSuggestion {
            alreadyProvidedLoginSuggestion = true
            
            let loginSuggestionAlertController = UIAlertController(title: "Consider Logging In", message: "You are not logged in. More features will be available to you if you login to this app.", preferredStyle: .alert)
            
            // Let user continue to the next view controller
            let continueAction = UIAlertAction(title: "Continue", style: .default) { (_) in
                
                if let addRecipeNavigationController = self.storyboard?.instantiateViewController(withIdentifier: "AddRecipeNav") as? UINavigationController {
                    self.present(addRecipeNavigationController, animated: true, completion: nil)
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            loginSuggestionAlertController.addAction(continueAction)
            loginSuggestionAlertController.addAction(cancelAction)
            
            present(loginSuggestionAlertController, animated: true, completion: nil)
        } else {
            if let addRecipeNavigationController = storyboard?.instantiateViewController(withIdentifier: "AddRecipeNav") as? UINavigationController {
                self.present(addRecipeNavigationController, animated: true, completion: nil)
            }
        }
    }
}

extension RecipeTableViewController: SideMenuDelegate {
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
        case "My Recipes":
            if let viewController = storyboard?.instantiateViewController(withIdentifier: "MyRecipesTableViewController") as? MyRecipesTableViewController {
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        case "Create Account":
            if let viewController = storyboard?.instantiateViewController(withIdentifier: "CreateAccountViewController") as? CreateAccountViewController {
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        default:
            break
        }
    }
}

extension RecipeTableViewController: UIViewControllerTransitioningDelegate {
    
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
