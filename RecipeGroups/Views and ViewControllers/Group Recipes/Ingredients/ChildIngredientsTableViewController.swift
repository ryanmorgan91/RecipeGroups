//
//  ChildIngredientsTableViewController.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/13/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import UIKit

class ChildIngredientsTableViewController: UITableViewController {

    var ingredients: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }

    override func viewDidLayoutSubviews() {
        // Set the viewController's preferredContentSize based on the intrinsicContentSize of the tableView
        self.preferredContentSize = self.tableView.intrinsicContentSize
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as! IngredientsTableViewCell

        cell.layoutMargins = UIEdgeInsets.zero
        cell.ingredientLabel.text = ingredients[indexPath.row]
        
        return cell
    }
    
    func setupView() {
        tableView.separatorInset = .zero
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
