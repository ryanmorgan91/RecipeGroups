//
//  GroupDetailTableViewController.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 6/2/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import UIKit
import MessageUI

class GroupDetailTableViewController: UITableViewController, MFMessageComposeViewControllerDelegate {
    
    var group: Group?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        if group?.creator == UserController.shared.user?.email {
            return 4
        } else {
            return 3
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if group?.creator == UserController.shared.user?.email {
            switch section {
            case 0, 1, 2:
                return 1
            case 3:
                return group?.members.count ?? 0
            default:
                return 0
            }
        } else {
            switch section {
            case 0, 1:
                return 1
            case 2:
                return group?.members.count ?? 0
            default:
                return 0
            }
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let group = group else { return UITableViewCell() }
        
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "GroupNameCell", for: indexPath) as? GroupNameTableViewCell {
                cell.groupLabel.text = group.name
                return cell
            }
        } else if indexPath.section == 1 && group.creator == UserController.shared.user?.email {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "GroupPasswordCell", for: indexPath) as? GroupPasswordTableViewCell {
                cell.passwordLabel.text = group.password
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "GroupMemberCell", for: indexPath) as? GroupMemberTableViewCell {
                if (indexPath.section == 1 && group.creator != UserController.shared.user?.email) || (indexPath.section == 2 && group.creator == UserController.shared.user?.email) {
                    cell.memberLabel.text = group.creator
                } else {
                    cell.memberLabel.text = group.members[indexPath.row]
                }
                return cell
            }
        }
        
        // If there is an error with the group, return an initialized UITableViewCell()
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let groupName = "Group Name"
        let creator = "Creator"
        let groupMembers = "Group Members"
        let groupPassword = "Group Password"
        
        switch section {
        case 0:
            return groupName
        case 1:
            if group?.creator == UserController.shared.user?.email {
                return groupPassword
            }
            return creator
        case 2:
            if group?.creator == UserController.shared.user?.email {
                return creator
            }
            return groupMembers
        default:
            return groupMembers
        }
    }
    
    func setupView() {
        if group?.creator == UserController.shared.user?.email {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(creatorGroupActionTapped))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Leave Group", style: .plain, target: self, action: #selector(leaveGroupTapped))
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func creatorGroupActionTapped() {
        guard let groupName = group?.name else { return }
        guard let password = group?.password else { return }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let inviteToJoinAction = UIAlertAction(title: "Invite Someone to Join", style: .default) { (_) in
            let composeVC = MFMessageComposeViewController()
            composeVC.messageComposeDelegate = self
            composeVC.body = """
                Join my Recipe Group!
                Group name: \(groupName)
                Password: \(password)
                """
            if MFMessageComposeViewController.canSendText() {
                self.present(composeVC, animated: true, completion: nil)
            }
        }
        let deleteGroupAction = UIAlertAction(title: "Delete Group", style: .default) { (_) in
            
            // Create a second UIAlertController to confirm that the user wants to delete the group
            let alertController = UIAlertController(title: "Delete Group", message: "Are you sure you want to delete this group?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            // Send a request to the server to delete the group if "Delete Group" button is tapped
            let deleteGroupAction = UIAlertAction(title: "Delete Group", style: .default) { (_) in
                GroupController.shared.deleteGroup(named: self.group!.name, completion: { (result) in
                    if result == "Success" {
                        GroupController.shared.processDeletedGroup(named: self.group!.name)
                        self.navigationController?.popViewController(animated: true)
                    }
                })
            }
            alertController.addAction(cancelAction)
            alertController.addAction(deleteGroupAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(inviteToJoinAction)
        alertController.addAction(deleteGroupAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func leaveGroupTapped() {
        let alertController = UIAlertController(title: "Leave Group", message: "Are you sure you want to leave this group?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Send a request to the server to delete the group if the "Leave Group" button is tapped
        let leaveGroupAction = UIAlertAction(title: "Leave Group", style: .default) { (_) in
            GroupController.shared.leaveGroup(named: self.group!.name, completion: { (result) in
                if result == "Success" {
                    GroupController.shared.processLeaveGroup(named: self.group!.name)
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(leaveGroupAction)
        present(alertController, animated: true, completion: nil)
    }

}
