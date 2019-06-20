//
//  ChildMenuTableViewController.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/16/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import UIKit

class ChildMenuTableViewController: UITableViewController {

    weak var delegate: SideMenuDelegate?
 
    @IBOutlet weak var recipesButton: UIButton!
    @IBOutlet weak var myGroupsButton: UIButton!
    @IBOutlet weak var myRecipesButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let parentViewController = self.parent as! MenuViewController
        parentViewController.createReference(to: self)
    }

    func setupView() {
        recipesButton.titleLabel?.font = UIFont(name: CustomStyles.shared.customFontName, size: 17)
        myGroupsButton.titleLabel?.font = UIFont(name: CustomStyles.shared.customFontName, size: 17)
        myRecipesButton.titleLabel?.font = UIFont(name: CustomStyles.shared.customFontName, size: 17)
        logoutButton.titleLabel?.font = UIFont(name: CustomStyles.shared.customFontName, size: 17)
        createAccountButton.titleLabel?.font = UIFont(name: CustomStyles.shared.customFontName, size: 17)
        if !UserController.shared.userIsLoggedIn {
            logoutButton.setTitle("Login", for: .normal)
        } else {
            logoutButton.setTitle("Logout", for: .normal)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 4 && UserController.shared.userIsLoggedIn {
            return 0
        }
        
        return 62
    }
    
    // Notify the delegate when user taps Recipes button
    @IBAction func recipesButtonTapped(_ sender: UIButton) {
        delegate?.userTapped(menuButton: "Recipes")
    }
    
    // Notify the delegate when user taps My Groups button
    @IBAction func myGroupsButtonTapped(_ sender: Any) {
        delegate?.userTapped(menuButton: "My Groups")
    }
    
    // Notify the delegate when user taps My Recipes button
    @IBAction func myRecipesButtonTapped(_ sender: Any) {
        delegate?.userTapped(menuButton: "My Recipes")
    }
    
    // Notify the delegate when user taps Logout button
    @IBAction func logoutButtonTapped(_ sender: Any) {
        delegate?.userTapped(menuButton: "Logout")
    }
    
    
    @IBAction func createAccountButtonTapped(_ sender: Any) {
        
        if !UserController.shared.userIsLoggedIn {
            delegate?.userTapped(menuButton: "Create Account")
        }
    }
    
}
