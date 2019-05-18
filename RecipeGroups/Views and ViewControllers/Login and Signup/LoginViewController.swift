//
//  LoginViewController.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/15/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    var userIsLoggedIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if userIsLoggedIn {
            performSegue(withIdentifier: "segueToMainVC", sender: nil)
        }
    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        if emailTextField.text == "" {
            animateTextField(textField: emailTextField)
            return
        } else if passwordTextField.text == "" {
            animateTextField(textField: passwordTextField)
            return
        }
        
        let email = emailTextField.text!.lowercased()
        let password = passwordTextField.text!
        let activityIndicatorBackground = displayActivityIndicator(onView: self.view)
        
        UserController.shared.loginUser(email: email, password: password) {
            
            self.removeActivityIndicator(activityBackgroundView: activityIndicatorBackground)
            if UserController.shared.successfulLogin {
                self.performSegue(withIdentifier: "segueToMainVC", sender: nil)
            } else {
                let alertController = UIAlertController(title: "Error", message: "Incorrect email or password", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
        }
        // To Do: Make sure email address is of type email address
        
    }
    
    func setupView() {
        let customColors = CustomColors()
        
        emailTextField.text = ""
        passwordTextField.text = ""
        passwordTextField.isSecureTextEntry = true
        loginButton.backgroundColor = .white
        loginButton.setTitleColor(customColors.customPink, for: .normal)
        loginButton.layer.cornerRadius = 10
        emailTextField.autocapitalizationType = .none
        passwordTextField.autocapitalizationType = .none
    }
    
    func animateTextField(textField: UITextField) {
    
        UIView.animate(withDuration: 0.3, animations: {
            let scaleTransform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            let translateTransform = CGAffineTransform(translationX: -20, y: 0)
            let comboTransform = scaleTransform.concatenating(translateTransform)
            textField.transform = comboTransform
            
        }) { (_) in
            UIView.animate(withDuration: 0.3, animations: {
                textField.transform = CGAffineTransform.identity
            })
        }
    }
}
