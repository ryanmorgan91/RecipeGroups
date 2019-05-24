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

        self.navigationItem.leftBarButtonItem = editButtonItem

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as! AddIngredientTableViewCell
        let customColors = CustomColors()
        cell.stepBullet.tintColor = customColors.customPink
        cell.ingredientTextField.text = ingredients[indexPath.row]
        return cell
    }
    

  
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 {
            return false
        } else {
            return true
        }
    }
    
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
            ingredients.insert("test", at: ingredients.count - 1)
            tableView.insertRows(at: [IndexPath(row: ingredients.count - 1, section: 0)], with: .automatic)
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
        
        print(ingredients)
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
