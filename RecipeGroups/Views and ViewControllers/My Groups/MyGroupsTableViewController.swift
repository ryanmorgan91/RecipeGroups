//
//  MyGroupsTableViewController.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/17/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import UIKit

class MyGroupsTableViewController: UITableViewController {
    
    let interactor = Interactor()
    let childMenuTableViewController = ChildMenuTableViewController()
    var groups: [Group] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: GroupController.groupDataUpdatedNotification, object: nil)
        
        updateUI()
        setupView()
    }
    
    @objc func updateUI() {
        self.groups = GroupController.shared.groups
        self.tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {

        return groups.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupsCell", for: indexPath) as! MyGroupsTableViewCell
        
        let group = groups[indexPath.section]
        cell.setupCell()
        cell.groupLabel.text = group.name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.contentView.layer.masksToBounds = true
    }

    func setupView() {
        tableView.separatorStyle = .none
        tableView.rowHeight = 100
        navigationItem.leftBarButtonItem?.tintColor = CustomStyles.shared.customPink
    }
    
    @IBAction func menuButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "openMenuFromMyGroups", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? MenuViewController {
            destinationViewController.transitioningDelegate = self
            destinationViewController.interactor = interactor
            destinationViewController.currentViewController = self
            destinationViewController.delegate = self
        } else if let destinationViewController = segue.destination as? GroupDetailTableViewController {
            let index = tableView.indexPathForSelectedRow!.section
            destinationViewController.group = groups[index]
        }
    }
    
    @IBAction func plusButtonTapped(_ sender: UIBarButtonItem) {
        
        // Restrict the group feature to logged in users
        if !UserController.shared.userIsLoggedIn {
            let notLoggedInController = UIAlertController(title: nil, message: "You must be logged in to join or create groups", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            notLoggedInController.addAction(dismissAction)
            self.present(notLoggedInController, animated: true, completion: nil)
            return
        }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let joinGroupAction = UIAlertAction(title: "Join a Group", style: .default) { (_) in
            self.performSegue(withIdentifier: "SegueFromMyGroupsToJoinAGroup", sender: nil)
        }
        let createGroupAction = UIAlertAction(title: "Create a Group", style: .default) { (_) in
            self.performSegue(withIdentifier: "SegueFromMyGroupsToCreateAGroup", sender: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(joinGroupAction)
        alertController.addAction(createGroupAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension MyGroupsTableViewController: SideMenuDelegate {
    func userTapped(menuButton: String) {

        switch menuButton {
        case "Logout":
            if !UserController.shared.userIsLoggedIn {
                if let viewConstroller = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                    self.navigationController?.pushViewController(viewConstroller, animated: true)
                }
            } else {
                UserController.shared.logoutUser()
            }
        case "Recipes":
            self.navigationController?.popToRootViewController(animated: true)
        case "My Recipes":
            if let viewController = storyboard?.instantiateViewController(withIdentifier: "MyRecipesTableViewController") as? MyRecipesTableViewController {
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        case "Create Account":
            if let viewController = storyboard?.instantiateViewController(withIdentifier: "CreateAccountViewController") as? CreateAccountViewController {
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        default:
            break
        }
    }
}

extension MyGroupsTableViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentMenuAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissMenuAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}
