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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let parentViewController = self.parent as! MenuViewController
        parentViewController.createReference(to: self)
    }

    
    @IBAction func recipesButtonTapped(_ sender: UIButton) {
        delegate?.userTapped(menuButton: "Recipes")
    }
    
    @IBAction func myGroupsButtonTapped(_ sender: Any) {
        delegate?.userTapped(menuButton: "My Groups")
    }
    
    @IBAction func myRecipesButtonTapped(_ sender: Any) {
        delegate?.userTapped(menuButton: "My Recipes")
    }
    
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        delegate?.userTapped(menuButton: "Logout")
    }
    
}
