//
//  CreateAccountViewController.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/16/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var childViewController: ChildCreateAccountTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        registerForKeyboardNotifications()
    }
    
    func setupView() {
        
        signInButton.setTitleColor(.white, for: .normal)
        signInButton.backgroundColor = CustomStyles.shared.customPink
        signInButton.layer.cornerRadius = 10
        signInButton.titleLabel?.font = UIFont(name: CustomStyles.shared.customFontNameWide, size: 24)
        
    }
    
    func createReference(to childViewController: ChildCreateAccountTableViewController) {
        self.childViewController = childViewController
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        guard let name = childViewController!.nameTextField.text else { return }
        guard let email = childViewController!.emailTextField.text?.lowercased() else { return }
        let firstPasswordTextField = childViewController!.firstPasswordTextField
        let secondPasswordTextField = childViewController!.secondPasswordTextField
        
        if (name == "" || email == "" || firstPasswordTextField?.text == "" || secondPasswordTextField?.text == "") {
            
            let alertController = UIAlertController(title: "Oops", message: "All fields must be filled in", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)

            return
            
        } else if (firstPasswordTextField?.text != secondPasswordTextField?.text) {
            let alertController = UIAlertController(title: "Oops", message: "Your passwords don't match.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
            
            return
        }
        
        guard let password = firstPasswordTextField?.text else { return }
        let activityIndicatorBackground = displayActivityIndicator(onView: self.view)
        
        UserController.shared.registerUser(name: name, email: email, password: password) { (result) in
            // Remove activity indicator
            self.removeActivityIndicator(activityBackgroundView: activityIndicatorBackground)
            
            if result == "Success" {
                UserController.shared.user = User(name: name, email: email)
                
                self.performSegue(withIdentifier: "newAccountSegue", sender: nil)
            } else {
                let alertController = UIAlertController(title: "Oops", message: result, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWasShown(_ notification: NSNotification) {
        guard let info = notification.userInfo,
            let keyboardFrameValue = info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else { return }
        
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardSize = keyboardFrame.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
