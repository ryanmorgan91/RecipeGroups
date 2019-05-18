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
    let customColors = CustomColors()
    var recipes: [Recipe] = []
    let childMenuTableViewController = ChildMenuTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadRecipes()
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = 200
        self.navigationItem.leftBarButtonItem?.tintColor = customColors.customPink
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return recipes.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeTableViewCell
        
        let recipe = recipes[indexPath.section]
        cell.recipeLabel.text = recipe.name
        cell.recipeImage.image = recipe.image
        cell.setupCell()

        return cell
    }
    
    func loadRecipes() {
//        if let savedRecipes = Recipe.loadRecipes() {
//            recipes = savedRecipes
//        } else {
            recipes = Recipe.loadSampleRecipes()
//        }
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
        }
    }
}

extension RecipeTableViewController: SideMenuDelegate {
    func userTapped(menuButton: String) {
        if menuButton == "logout" {
            UserController.shared.logoutUser {
                print("Recipe VC delegate")
                print(menuButton)
                self.performSegue(withIdentifier: "signOutFromRecipeTableView", sender: nil)
            }
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
