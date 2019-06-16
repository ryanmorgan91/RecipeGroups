//
//  ChildResetPasswordTableViewController.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 6/3/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import UIKit

class ChildResetPasswordTableViewController: UITableViewController {

    @IBOutlet weak var emailImage: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let parentViewController = self.parent as! ResetPasswordViewController
        parentViewController.createReference(to: self)
    }

    func setupView() {
        let customSyles = CustomStyles()
        emailImage.tintColor = customSyles.customPink
        self.tableView.backgroundColor = .clear
        emailTextField.font = UIFont(name: CustomStyles.shared.customFontName, size: 17)
    }
}
