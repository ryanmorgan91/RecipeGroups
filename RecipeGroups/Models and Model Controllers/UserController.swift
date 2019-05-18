//
//  UserController.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/15/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import Foundation

class UserController {
    
    static let shared = UserController()
    
    var userIsLoggedIn = false
    var successfulLogin = false
    
    let baseURL = URL(string: "http://127.0.0.1:5000/")!
    
    func loginUser(email: String, password: String, completionHandler: @escaping () -> ()) {
        let data: [String: String] = [
            "email": email,
            "password": password
        ]
        
        let url = baseURL.appendingPathComponent("login")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let result = try? jsonDecoder.decode([String: String].self, from: data) {
                if result["Success"] == "true" || result["Success"] == "User is already logged in" {
                    self.successfulLogin = true
                } else {
                    self.successfulLogin = false
                }
                DispatchQueue.main.async {
                    completionHandler()
                }
            }
        }
        task.resume()
    }
    
}
