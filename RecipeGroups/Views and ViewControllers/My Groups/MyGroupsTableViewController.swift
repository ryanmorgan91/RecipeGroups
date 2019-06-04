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
        
//        loadGroups()
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
        let customColors = CustomColors()
        tableView.separatorStyle = .none
        tableView.rowHeight = 100
        navigationItem.leftBarButtonItem?.tintColor = customColors.customPink
    }
    
//    func loadGroups() {
//        // if ...
//
//        groups = Group.loadSampleGroups()
//    }
    
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
            UserController.shared.logoutUser {
                self.performSegue(withIdentifier: "SignOutFromMyGroups", sender: nil)
            }
        case "Recipes":
            performSegue(withIdentifier: "SegueFromMyGroupsToRecipes", sender: nil)
        case "My Recipes":
            performSegue(withIdentifier: "SegueFromMyGroupsToMyRecipes", sender: nil)
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