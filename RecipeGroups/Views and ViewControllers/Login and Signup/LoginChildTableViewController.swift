//
//  LoginChildTableViewController.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 6/1/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import UIKit

class LoginChildTableViewController: UITableViewController {

    @IBOutlet weak var emailImage: UIImageView!
    @IBOutlet weak var passwordImage: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let parentViewController = self.parent as! LoginViewController
        parentViewController.createReference(to: self)
    }
    
    func setupView() {
        emailImage.tintColor = .white
        passwordImage.tintColor = .white
        emailTextField.textColor = .white
        
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textContentType = .password
        passwordTextField.autocapitalizationType = .none
        passwordTextField.font = UIFont(name: CustomStyles.shared.customFontName, size: 17)
        
        emailTextField.autocapitalizationType = .none
        emailTextField.textContentType = .username
        emailTextField.keyboardType = .emailAddress
        emailTextField.font = UIFont(name: CustomStyles.shared.customFontName, size: 17)
        
        self.tableView.backgroundColor = .clear
    }
    
}
