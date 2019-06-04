//
//  GroupController.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/23/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import Foundation

final class GroupController {
    static let groupDataUpdatedNotification = Notification.Name("GroupController.groupDataUpdated")
    
    static let shared = GroupController()
    let baseURL = RecipeController.shared.baseURL
    var groups: [Group] = []
    
    func process(groups: [Group]) {
        self.groups = groups

        NotificationCenter.default.post(name: GroupController.groupDataUpdatedNotification, object: nil)
    }
    
    func processNewGroup(named groupName: String) {
        let group = Group(name: groupName, creator: UserController.shared.user!.email, members: [UserController.shared.user!.email])
        self.groups.append(group)
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: GroupController.groupDataUpdatedNotification, object: nil)
        }
    }
    
    func processDeletedGroup(named groupName: String) {
        groups.removeAll { $0.name == groupName }
        NotificationCenter.default.post(name: GroupController.groupDataUpdatedNotification, object: nil)
    }
    
    func processLeaveGroup(named groupName: String) {
        groups.removeAll { $0.name == groupName }
        NotificationCenter.default.post(name: GroupController.groupDataUpdatedNotification, object: nil)
    }
    
    func fetchGroups() {
        let url = baseURL.appendingPathComponent("get_groups")
        guard let user = UserController.shared.user else { return }
        let sentData: [String: String] = ["email": user.email]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(sentData)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let groups = try? jsonDecoder.decode([Group].self, from: data) {
                DispatchQueue.main.async {
                    self.process(groups: groups)
                }
            } else {
                print("failure")
            }
        }
        task.resume()
    }
    
    func createGroup(named groupName: String, withPassword password: String, completion: @escaping (String) -> ()) {
        let url = baseURL.appendingPathComponent("create_group")
        guard let user = UserController.shared.user else { return }
        let sentData: [String: String] = [
            "email": user.email,
            "groupName": groupName,
            "password": password
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(sentData)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let response = try? jsonDecoder.decode([String: String].self, from: data),
                let result = response["Result"] {
                print(response)
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
        task.resume()
    }
    
    func joinGroup(named groupName: String, withPassword password: String, completion: @escaping (String) -> ()) {
        let url = baseURL.appendingPathComponent("join_group")
        guard let user = UserController.shared.user else { return }
        let sentData: [String: String] = [
            "email": user.email,
            "groupName": groupName,
            "password": password
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(sentData)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let response = try? jsonDecoder.decode([String: String].self, from: data),
                let result = response["Result"] {
                print(response)
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
        task.resume()
    }
    
    func deleteGroup(named groupName: String, completion: @escaping (String) -> ()) {
        let url = baseURL.appendingPathComponent("delete_group")
        let sentData: [String: String] = ["group": groupName]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(sentData)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let response = try? jsonDecoder.decode([String: String].self, from: data),
                let result = response["Result"] {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
        task.resume()
    }
    
    func leaveGroup(named groupName: String, completion: @escaping (String) -> ()) {
        guard let user = UserController.shared.user else { return }
        let url = baseURL.appendingPathComponent("leave_group")
        let sentData: [String: String] = [
            "email": user.email,
            "groupName": groupName
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(sentData)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let response = try? jsonDecoder.decode([String: String].self, from: data),
                let result = response["Result"] {
                DispatchQueue.main.async {
                    completion(result)
                    print(result)
                }
            }
        }
        task.resume()
    }
}
