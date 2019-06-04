//
//  CreateAGroupTableViewController.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/31/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import UIKit

class CreateAGroupTableViewController: UITableViewController {

    
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var passwordImage: UIImageView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var reenterPasswordImage: UIImageView!
    @IBOutlet weak var reenterPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }


    
    @IBAction func createGroupButtonTapped(_ sender: UIBarButtonItem) {
        guard groupNameTextField.text != "" else { return }
        guard passwordTextField.text != "" else { return }
        guard passwordTextField.text == reenterPasswordTextField.text else {
            let alertController = UIAlertController(title: "Oops", message: "Password fields do not match", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        let groupName = groupNameTextField.text!
        let password = passwordTextField.text!
        
        GroupController.shared.createGroup(named: groupName, withPassword: password) { (result) in
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
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func setupView() {
        let customColors = CustomColors()
        groupImage.tintColor = customColors.customPink
        passwordImage.tintColor = customColors.customPink
        reenterPasswordImage.tintColor = customColors.customPink
        
        passwordTextField.textContentType = .newPassword
        passwordTextField.isSecureTextEntry = true
        reenterPasswordTextField.textContentType = .newPassword
        reenterPasswordTextField.isSecureTextEntry = true
    }
    
}
