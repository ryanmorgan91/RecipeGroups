//
//  JoinGroupTableViewController.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/31/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import UIKit

class JoinGroupTableViewController: UITableViewController {

    
    @IBOutlet weak var groupNameImage: UIImageView!
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var passwordImage: UIImageView!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    func setupView() {
        groupNameImage.tintColor = CustomStyles.shared.customPink
        passwordImage.tintColor = CustomStyles.shared.customPink
        passwordTextField.isSecureTextEntry = true
        groupNameTextField.font = UIFont(name: CustomStyles.shared.customFontName, size: 17)
        passwordTextField.font = UIFont(name: CustomStyles.shared.customFontName, size: 17)
    }

    @IBAction func joinButtonTapped(_ sender: UIBarButtonItem) {
        guard groupNameTextField.text != "" else { return }
        guard passwordTextField.text != "" else { return }
        let groupName = groupNameTextField.text!
        let password = passwordTextField.text!
        
        guard !GroupController.shared.groups.contains(where: { $0.name == groupName  }) else {
            let message = "You are already a member of a group with that name"
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        GroupController.shared.joinGroup(named: groupName, withPassword: password) { (result) in
            if result == "Success" {
                GroupController.shared.processNewGroup(named: groupName)
                self.dismiss(animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "Error", message: result, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}
