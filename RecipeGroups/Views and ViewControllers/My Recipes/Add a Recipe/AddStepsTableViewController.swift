//
//  AddStepsTableViewController.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/21/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import UIKit

class AddStepsTableViewController: UITableViewController {

    var steps: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isEditing = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return steps.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StepCell", for: indexPath) as! AddStepsTableViewCell
        cell.stepBullet.tintColor = CustomStyles.shared.customPink
        cell.stepTextField.text = steps[indexPath.row]
        
        return cell
    }
    
    // Support conditional editing of the table view
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    // Allow insert if row = 0, else allow delete
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath == IndexPath(row: 0, section: 0) {
            return .insert
        } else {
            return .delete
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            steps.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            steps.insert("", at: 0)
            tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "SaveUnwindFromAddSteps" else { return }
        
        var counter = 0

        for i in 0 ... steps.count - 1 {
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as! AddStepsTableViewCell
            let step = cell.stepTextField.text ?? ""
            if step != "" {
                self.steps[counter] = step
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
        
        for i in 0 ... steps.count - 1 {
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as! AddStepsTableViewCell
            let step = cell.stepTextField.text ?? ""
            if step != "" {
                self.steps[counter] = step
                counter += 1
            }
        }
        
        coder.encode(steps, forKey: "StepsKey")
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        
        steps = coder.decodeObject(forKey: "StepsKey") as! [String]
        tableView.reloadData()
    }
}
