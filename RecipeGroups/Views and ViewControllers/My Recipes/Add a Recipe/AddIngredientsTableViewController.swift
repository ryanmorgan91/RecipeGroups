//
//  AddIngredientsTableViewController.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/21/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import UIKit

class AddIngredientsTableViewController: UITableViewController {
    
    var ingredients: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isEditing = true
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as! AddIngredientTableViewCell
        
        cell.stepBullet.tintColor = CustomStyles.shared.customPink
        cell.ingredientTextField.text = ingredients[indexPath.row]
        return cell
    }

    // Support conditional editing of the table view for the first section only
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 {
            return false
        } else {
            return true
        }
    }
    
    // Allow insert if section = 0, else allow delete
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath == IndexPath(row: 0, section: 0) {
            return .insert
        } else {
            return .delete
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ingredients.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            ingredients.insert("", at: 0)
            tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "SaveUnwindFromAddIngredients" else { return }
        
        var counter = 0
        
        for i in 0 ... ingredients.count - 1 {
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as! AddIngredientTableViewCell
            let ingredient = cell.ingredientTextField.text ?? ""
            if ingredient != "" {
                self.ingredients[counter] = ingredient
                counter += 1
            }
        }
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        
        var counter = 0
        
        for i in 0 ... ingredients.count - 1 {
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as! AddIngredientTableViewCell
            let ingredient = cell.ingredientTextField.text ?? ""
            if ingredient != "" {
                self.ingredients[counter] = ingredient
                counter += 1
            }
        }
        
        coder.encode(ingredients, forKey: "IngredientsKey")
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        
        ingredients = coder.decodeObject(forKey: "IngredientsKey") as! [String]
        tableView.reloadData()
    }
}
