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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: RecipeController.recipeDataUpdatedNotification, object: nil)
        
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
        configure(cell, forItemAt: indexPath)
        
        /* comment the following to remove sample images */
        
//        let recipe = recipes[indexPath.section]
//        cell.recipeLabel.text = recipe.name
//        cell.recipeImage.image = recipe.image
        
        return cell
    }
    
    func setupView() {
        let customColors = CustomColors()
        tableView.separatorStyle = .none
        tableView.rowHeight = 200
        navigationItem.leftBarButtonItem?.tintColor = customColors.customPink
        
    }
    
    @objc func updateUI() {
        self.recipes = RecipeController.shared.recipes
        self.tableView.reloadData()
    }
    
    func configure(_ cell: RecipeTableViewCell, forItemAt indexPath: IndexPath) {
        let recipe = recipes[indexPath.section]
        cell.recipeLabel.text = recipe.name
        RecipeController.shared.fetchImage(url: recipe.imageURL!) { (image) in
            guard let image = image else { return }
            DispatchQueue.main.async {
                if let currentIndexPath = self.tableView.indexPath(for: cell),
                    currentIndexPath != indexPath {
                    return
                }
                cell.recipeImage.image = image
                cell.setNeedsLayout()
            }
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
}

extension RecipeTableViewController: SideMenuDelegate {
    func userTapped(menuButton: String) {
        switch menuButton {
        case "Logout":
            if UserController.shared.user?.name == "Ryan" {
                self.performSegue(withIdentifier: "SignOutFromRecipeTableView", sender: nil)
            }
            
            UserController.shared.logoutUser {
                self.performSegue(withIdentifier: "SignOutFromRecipeTableView", sender: nil)
            }
        case "My Groups":
            self.performSegue(withIdentifier: "SegueFromRecipesToMyGroups", sender: nil)
        case "My Recipes":
            self.performSegue(withIdentifier: "SegueFromRecipesToMyRecipes", sender: nil)
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
