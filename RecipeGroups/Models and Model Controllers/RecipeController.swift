//
//  RecipeController.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/13/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import Foundation

extension URL {
    
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.compactMap({ URLQueryItem(name: $0.0, value: $0.1) })
        
        return components?.url
    }
    
}

class RecipeController {
    static let shared = RecipeController()
    
    let baseURL = URL(string: "http://127.0.0.1:5000/api/")!
    let queries: [String: String] = ["user":"ryan"]
    
    func sendRecipe() {
        let url = baseURL.appendingPathComponent("get_recipes")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let data: [String: String] = ["user": "ryan"]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data,
                let result = String(data: data, encoding: .utf8) {
                print(result)
            }
        }
        task.resume()
    }
}
