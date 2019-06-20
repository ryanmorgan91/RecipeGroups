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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    @IBAction func createGroupButtonTapped(_ sender: UIBarButtonItem) {

        guard groupNameTextField.text != "" else { return }
      
        let groupName = groupNameTextField.text!
        let password = generateRandomPassword()
        
        // Send a create group request to the server
        GroupController.shared.createGroup(named: groupName, withPassword: password) { (result) in
            if result == "Success" {
                GroupController.shared.processCreatedGroup(named: groupName, withPassword: password)
                let alertController = UIAlertController(title: "Success", message: """
                        You have successfully created a new group.
                        If you would like to invite others to join your group, just tell them the name of your group and the password below:
                        Group Name: \(groupName)
                        Password: \(password)
                        """, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: { (_) in
                    self.dismiss(animated: true, completion: nil)
                })
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
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
        groupImage.tintColor = CustomStyles.shared.customPink
        groupNameTextField.font = UIFont(name: CustomStyles.shared.customFontName, size: 17)
    }
    
    func generateRandomPassword() -> String {
        var password = ""
        let passwordLength = 8
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var arrayCharacters: [Character] = []
        for character in characters {
            arrayCharacters += characters
        }
        for _ in 0 ... passwordLength - 1 {
            let randomInt = Int.random(in: 0...arrayCharacters.count - 1)
            password += "\(arrayCharacters[randomInt])"
        }
        return password
    }
    
}
