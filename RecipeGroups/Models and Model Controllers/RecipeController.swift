//
//  RecipeController.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/13/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import Foundation
import UIKit

extension URL {
    
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.compactMap({ URLQueryItem(name: $0.0, value: $0.1) })
        
        return components?.url
    }
    
}

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}

class RecipeController {
    static let shared = RecipeController()
    
    static let recipeDataUpdatedNotification = Notification.Name("RecipeController.recipeDataUpdated")
    
    var recipes: [Recipe] = []
    
    let baseURL = URL(string: "http://127.0.0.1:5000/")!
    //    let queries: [String: String] = ["user":"ryan"]

    func sendRecipe(recipe: Recipe, completion: @escaping () -> ()) {
        let url = baseURL.appendingPathComponent("add_recipe")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = "Boundary-" + UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        guard let user = UserController.shared.user else { return }
        
        let data: [String: Any] = [
            "email": user.email,
            "title": recipe.name,
            "description": recipe.description,
            "category": recipe.category.rawValue,
            "cookingTime": recipe.cookTime.rawValue,
            "difficulty": recipe.cookingDifficulty.rawValue
        ]
        
        let arrayParameters: [String: [String]] = [
            "ingredients": recipe.ingredients,
            "steps": recipe.steps
        ]
        
        let imageFileName = "recipeImage.jpg"
        
        guard let imageData = recipe.image?.jpegData(compressionQuality: 1.0) else { return }
        
        request.httpBody = createBody(parameters: data, arrayParameters: arrayParameters, boundary: boundary, data: imageData, mimeType: "image/jpg", filename: imageFileName)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let recipe = try? jsonDecoder.decode(Recipe.self, from: data) {
                DispatchQueue.main.async {
                    self.processNew(recipe: recipe)
                    completion()
                }
            }
        }
        task.resume()
    }
    
    private func createBody(parameters: [String: Any], arrayParameters: [String: [String]], boundary: String, data: Data, mimeType: String, filename: String) -> Data {
        
        let body = NSMutableData()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        
        for (key, value) in arrayParameters {
            for i in value {
                body.appendString(boundaryPrefix)
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(i)\r\n")
            }
        }
        
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"imagefile\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))
        
        return body as Data
    }
    
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data,
                let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
//    func sendRecipes(recipe: Recipe) {
//        let url = baseURL.appendingPathComponent("add_recipes")
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
//        guard let imageData = recipe.image.jpegData(compressionQuality: 1.0) else { return }
//        let imageDataAsString = imageData.base64EncodedString(options: .lineLength64Characters)
//
//        let data: [String: Any] = [
//            "title": recipe.name,
//            "description": recipe.description,
//            "category": recipe.category.rawValue,
//            "cookingTime": recipe.cookTime.rawValue,
//            "difficulty": recipe.cookingDifficulty.rawValue,
//            "ingredients": recipe.ingredients,
//            "steps": recipe.steps,
//            "recipeImage": imageDataAsString
//        ]
//        let ingredients: [String: [String]] = [
//            "ingredients": recipe.ingredients,
//            "steps": recipe.steps
//        ]
//        let imageData = UIImage.JPEG
//        // TO DO: Figure out how to send image
//    }
    
    func process(recipes: [Recipe]) {
        self.recipes = recipes
        print ("process test")
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: RecipeController.recipeDataUpdatedNotification, object: nil)
            print("process test 2")
        }
    }
    
    func processNew(recipe: Recipe) {
        self.recipes.insert(recipe, at: 0)
        
        NotificationCenter.default.post(name: RecipeController.recipeDataUpdatedNotification, object: nil)
    }
    
    func fetchRecipes() {
        let url = baseURL.appendingPathComponent("get_recipes_by_groups")
        
        
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
                let recipes = try? jsonDecoder.decode([Recipe].self, from: data) {
                    self.process(recipes: recipes)
                    print("success")
            } else {
                print("failure")
            }
        }
        task.resume()
    }
    
    
    func loadRecipes() {
        recipes = Recipe.loadSampleRecipes()
    }
}
