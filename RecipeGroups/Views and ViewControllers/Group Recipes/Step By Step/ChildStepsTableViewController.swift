//
//  ChildStepsTableViewController.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/13/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import UIKit

class ChildStepsTableViewController: UITableViewController {

    var steps: [String] = ["Step 1 is ...", "Step 2 ..."]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
    }
    
    override func viewDidLayoutSubviews() {
        // Set the viewController's preferredContentSize based on the intrinsicContentSize of the tableView
        self.preferredContentSize = self.tableView.intrinsicContentSize
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return steps.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stepCell", for: indexPath) as! StepTableViewCell
        cell.stepLabel.text = steps[indexPath.row]
        cell.stepBullet.tintColor = CustomStyles.shared.customPink
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! StepTableViewCell
        cell.isComplete = !cell.isComplete
    }
}
