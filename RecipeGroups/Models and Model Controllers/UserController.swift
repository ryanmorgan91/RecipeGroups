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
    var user: User?
    let baseURL = Secret.shared.baseURL
    
    func updateUser(name: String, email: String) {
        self.user = User(name: name, email: email)
        
        
         
        RecipeController.shared.fetchRecipes()
        GroupController.shared.fetchGroups()
    
        /* To turn off networking and use samples instead, uncommenting the following and comment the lines above 
         
        GroupController.shared.groups = Group.loadSampleGroups()
         
        */
        
        /* Use the following to send sample recipes to the server
         
            let recipes = Recipe.loadSampleRecipes()
            for recipe in recipes {
                RecipeController.shared.sendRecipe(recipe: recipe) {
                    //
                }
            }
         
        */
    }
    
    // Send a request to the server to login the user
    func loginUser(email: String, password: String, completionHandler: @escaping (Bool) -> ()) {
        let sentData: [String: String] = [
            "email": email,
            "password": password
        ]
        
        let url = baseURL.appendingPathComponent("login")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(sentData)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let result = try? jsonDecoder.decode([String: String].self, from: data) {
                if result["Success"] == "true" || result["Success"] == "User is already logged in" {
                    
                    if let name = result["Name"],
                        let email = result["Email"] {
                        self.updateUser(name: name, email: email)
                        DispatchQueue.main.async {
                            completionHandler(true)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completionHandler(false)
                    }
                }
            }
        }
        task.resume()
    }
    
    func registerUser(name: String, email: String, password: String, completionHandler: @escaping (String) -> ()) {
        let sentData: [String: String] = [
            "name": name,
            "email": email,
            "password": password
        ]
        
        let url = baseURL.appendingPathComponent("register")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(sentData)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let response = try? jsonDecoder.decode([String:String].self, from: data),
                    let result = response["Result"] {
                DispatchQueue.main.async {
                    completionHandler(result)
                }
            }
        }
        task.resume()
    }
    
    func logoutUser(completionHandler: @escaping () -> ()) {
        let url = baseURL.appendingPathComponent("logout")
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let response = try? jsonDecoder.decode([String: String].self, from: data) {
                DispatchQueue.main.async {
                    completionHandler()
                }
            }
        }
        task.resume()
    }
    
    func resetPassword(completion: @escaping (String) -> ()) {
        guard let user = UserController.shared.user else { return }
        
        let url = baseURL.appendingPathComponent("reset_password_request")
        let sentData = ["email": user.email]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(sentData)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, request, error) in
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
    
    // For state restoration
    func saveUser() {
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let userFileURL = documentsDirectoryURL.appendingPathComponent("user").appendingPathExtension("json")
        let jsonEncoder = JSONEncoder()
        if let data = try? jsonEncoder.encode(user) {
            try? data.write(to: userFileURL)
        }
    }
   
    // For state restoration
    func loadUser() -> User? {
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let userFileURL = documentsDirectoryURL.appendingPathComponent("user").appendingPathExtension("json")
        guard let data = try? Data(contentsOf: userFileURL) else { return nil }
        let jsonDecoder = JSONDecoder()
        if let user = try? jsonDecoder.decode(User.self, from: data) {
            return user
        }
        return nil
    }
}
