//
//  MenuViewController.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/16/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    var interactor: Interactor? = nil
    var childViewController: ChildMenuTableViewController?
    var currentViewController: UIViewController?
    weak var delegate: SideMenuDelegate?
   
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userIcon: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        // Do any additional setup after loading the view.
    }
    
    func setupView() {
        userNameLabel.font = UIFont(name: CustomStyles.shared.customFontName, size: 17)
        userNameLabel.text = UserController.shared.user?.name
        userIcon.tintColor = CustomStyles.shared.customBlue
        userNameLabel.textColor = CustomStyles.shared.customBlue
    }
    
    @IBAction func closeMenu(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handleGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let progress = MenuHelper.calculateProgress(translationInView: translation, viewBounds: view.bounds, direction: .left)
        
        MenuHelper.mapGestureStateToInteractor(gestureState: sender.state, progress: progress, interactor: interactor) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func createReference(to childViewController: ChildMenuTableViewController) {
        self.childViewController = childViewController
        childViewController.delegate = self
    }

}

extension MenuViewController: SideMenuDelegate {
    func userTapped(menuButton: String) {
        dismiss(animated: true) {
            self.delegate?.userTapped(menuButton: menuButton)
        }
    }
}
