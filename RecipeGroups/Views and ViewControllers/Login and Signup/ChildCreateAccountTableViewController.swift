//
//  ChildCreateAccountTableViewController.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/16/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import UIKit

class ChildCreateAccountTableViewController: UITableViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstPasswordTextField: UITextField!
    @IBOutlet weak var secondPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    func setupView() {
        self.tableView.contentInset = .zero
        firstPasswordTextField.isSecureTextEntry = true
        firstPasswordTextField.textContentType = .newPassword
        
        secondPasswordTextField.isSecureTextEntry = true
        secondPasswordTextField.textContentType = .newPassword
        
        emailTextField.autocapitalizationType = .none
        emailTextField.textContentType = .username
        emailTextField.keyboardType = .emailAddress
        nameTextField.font = UIFont(name: CustomStyles.shared.customFontName, size: 17)
        emailTextField.font = UIFont(name: CustomStyles.shared.customFontName, size: 17)
        firstPasswordTextField.font = UIFont(name: CustomStyles.shared.customFontName, size: 17)
        secondPasswordTextField.font = UIFont(name: CustomStyles.shared.customFontName, size: 17)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Create reference to parentViewController when viewDidAppear
        let parentViewController = self.parent as! CreateAccountViewController
        parentViewController.createReference(to: self)
    }
}
