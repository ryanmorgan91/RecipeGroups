//
//  LoginViewController.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/15/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!

    var childViewController: LoginChildTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    func createReference(to childViewController: LoginChildTableViewController) {
        self.childViewController = childViewController
    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let emailTextField = childViewController?.emailTextField else { return }
        guard let passwordTextField = childViewController?.passwordTextField else { return }
        
        
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
        
        UserController.shared.loginUser(email: email, password: password) { (success) in
            
            self.removeActivityIndicator(activityBackgroundView: activityIndicatorBackground)
            if success {
                print("Login test - success")
                self.performSegue(withIdentifier: "segueToMainVC", sender: nil)
            } else {
                let alertController = UIAlertController(title: "Error", message: "Incorrect email or password", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func setupView() {
        let customColors = CustomColors()
        
        loginButton.backgroundColor = .white
        loginButton.setTitleColor(customColors.customPink, for: .normal)
        loginButton.layer.cornerRadius = 10
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
