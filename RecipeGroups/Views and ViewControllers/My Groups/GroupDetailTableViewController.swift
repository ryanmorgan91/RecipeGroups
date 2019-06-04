//
//  GroupDetailTableViewController.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 6/2/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import UIKit

class GroupDetailTableViewController: UITableViewController {
    
    var group: Group?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let group = group else { return 0 }
        
        switch section {
        case 0, 1:
            return 1
        case 2:
            return group.members.count
        default:
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let group = group else { return UITableViewCell() }
        
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "GroupNameCell", for: indexPath) as? GroupNameTableViewCell {
                cell.groupLabel.text = group.name
                return cell
            }
        } else if indexPath.section == 1 || indexPath.section == 2 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "GroupMemberCell", for: indexPath) as? GroupMemberTableViewCell {
                if indexPath.section == 1 {
                    cell.memberLabel.text = group.creator
                } else {
                    cell.memberLabel.text = group.members[indexPath.row]
                }
                return cell
            }
        }
        
        // Default return value in case there is an error
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let groupName = "Group Name"
        let creator = "Creator"
        let groupMembers = "Group Members"
        
        if section == 0 {
            return groupName
        } else if section == 1 {
            return creator
        } else {
            return groupMembers
        }
    }
    
    func setupView() {
        if group?.creator == UserController.shared.user?.email {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete Group", style: .plain, target: self, action: #selector(deleteGroupTapped))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Leave Group", style: .plain, target: self, action: #selector(leaveGroupTapped))
        }
    }
    
    @objc func deleteGroupTapped() {
        let alertController = UIAlertController(title: "Delete Group", message: "Are you sure you want to delete this group?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
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
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func leaveGroupTapped() {
        let alertController = UIAlertController(title: "Leave Group", message: "Are you sure you want to leave this group?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let leaveGroupAction = UIAlertAction(title: "Leave Group", style: .default) { (_) in
            GroupController.shared.deleteGroup(named: self.group!.name, completion: { (result) in
                if result == "Success" {
                    print(result)
                    GroupController.shared.processLeaveGroup(named: self.group!.name)
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
        alertController.addAction(cancelAction)
        alertController.addAction(leaveGroupAction)
        present(alertController, animated: true, completion: nil)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
