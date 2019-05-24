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
    
    var groups: [Group] = []
    
    func process(groups: [Group]) {
        self.groups = groups

        DispatchQueue.main.async {
            NotificationCenter.default.post(name: GroupController.groupDataUpdatedNotification, object: nil)
        }
    }
    
    func fetchGroups() {
        
        let baseURL = RecipeController.shared.baseURL
        let url = baseURL.appendingPathComponent("get_groups")
        
        guard let user = UserController.shared.user else { return }
        let data: [String: String] = ["email": user.email]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            
            
            if let data = data,
                //                let result = String(data: data, encoding: .utf8) {
                //                print(result)
                //            }
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
    
}
