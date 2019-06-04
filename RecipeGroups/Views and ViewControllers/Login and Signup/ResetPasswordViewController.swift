//
//  ResetPasswordViewController.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 6/3/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var resetPasswordButton: UIButton!
    
    var childViewController: ChildResetPasswordTableViewController?
    let resetPassword = "Reset Password"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    func setupView() {
        let customColors = CustomColors()
        resetPasswordButton.setTitle(resetPassword, for: .normal)
        resetPasswordButton.backgroundColor = .white
        resetPasswordButton.setTitleColor(customColors.customPink, for: .normal)
        
        self.navigationItem.title = resetPassword
    }
    
    func createReference(to childViewController: ChildResetPasswordTableViewController) {
        self.childViewController = childViewController
    }
    
    @IBAction func resetPasswordButtonTapped(_ sender: UIButton) {
        guard let child = childViewController else { return }
        guard child.emailTextField.text != "" else { return }
        UserController.shared.resetPassword { (result) in
            let alertController = UIAlertController(title: "Password Reset Request", message: result, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: { (_) in
                if result == "Check your email for password reset instructions" {
                    self.dismiss(animated: true, completion: nil)
                }
            })
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
