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
        
        self.tableView.contentInset = .zero
        firstPasswordTextField.isSecureTextEntry = true
        firstPasswordTextField.textContentType = .newPassword
        
        secondPasswordTextField.isSecureTextEntry = true
        secondPasswordTextField.textContentType = .newPassword
        
        emailTextField.autocapitalizationType = .none
        emailTextField.textContentType = .username
        emailTextField.keyboardType = .emailAddress
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let parentViewController = self.parent as! CreateAccountViewController
        parentViewController.createReference(to: self)
    }
 
   
}
