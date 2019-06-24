//
//  RecipeController.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/13/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import Foundation
import UIKit

class RecipeController {
    
    static let shared = RecipeController()
    
    static let recipeDataUpdatedNotification = Notification.Name("RecipeController.recipeDataUpdated")
    
    var recipes: [Recipe] = []
    var savedRecipes: [Recipe] = []
    var likedRecipes: [Recipe] = []
    let baseURL = Secret.shared.baseURL

    func sendRecipe(recipe: Recipe) {
        let url = baseURL.appendingPathComponent("add_recipe")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = "Boundary-" + UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        guard let user = UserController.shared.user else { return }
        
        let textData: [String: Any] = [
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
        
        guard let imageData = recipe.image?.jpegData(compressionQuality: 0.6) else { return }
        
        request.httpBody = createBody(parameters: textData, arrayParameters: arrayParameters, boundary: boundary, data: imageData, mimeType: "image/jpg", filename: imageFileName)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                self.processNew(recipe: recipe)
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
    
    func process(recipes: [Recipe]) {
        self.recipes += recipes
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: RecipeController.recipeDataUpdatedNotification, object: nil)
            
        }
    }
    
    func processNew(recipe: Recipe) {
        self.recipes.insert(recipe, at: 0)
        recipe.wasUploaded = true
        RecipeController.shared.saveUserRecipe(recipe)
        NotificationCenter.default.post(name: RecipeController.recipeDataUpdatedNotification, object: nil)
    }
    
    func fetchRecipes() {
        let url = baseURL.appendingPathComponent("get_recipes_by_groups")
        
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
                let recipes = try? jsonDecoder.decode([Recipe].self, from: data) {
                    self.process(recipes: recipes)
            }
        }
        task.resume()
    }
    
    
    func loadLikedRecipes() {
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let likedRecipeFileURL = documentsDirectoryURL.appendingPathComponent("likedRecipe").appendingPathExtension("json")
        guard let data = try? Data(contentsOf: likedRecipeFileURL) else { return }
        let jsonDecoder = JSONDecoder()
        if let recipes = try? jsonDecoder.decode([Recipe].self, from: data) {
            likedRecipes = recipes
            print("Test loading liked recipe")
        }
    }
    
    func saveLikedRecipe(_ recipe: Recipe) {
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let likedRecipeFileURL = documentsDirectoryURL.appendingPathComponent("likedRecipe").appendingPathExtension("json")
        let jsonEncoder = JSONEncoder()
        likedRecipes.append(recipe)
        if let data = try? jsonEncoder.encode(likedRecipes) {
            try? data.write(to: likedRecipeFileURL)
            print("Test saving liked recipe")
        }
    }
    
    func saveUserRecipe(_ recipe: Recipe) {
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let recipeFileURL = documentsDirectoryURL.appendingPathComponent("recipe").appendingPathExtension("json")
        let jsonEncoder = JSONEncoder()
        savedRecipes.append(recipe)
        if let data = try? jsonEncoder.encode(savedRecipes) {
            try? data.write(to: recipeFileURL)
            print("Test saving recipe")
        }
    }
    
    func loadSavedRecipes() {
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let recipeFileURL = documentsDirectoryURL.appendingPathComponent("recipe").appendingPathExtension("json")
        guard let data = try? Data(contentsOf: recipeFileURL) else { return }
        let jsonDecoder = JSONDecoder()
        if let recipes = try? jsonDecoder.decode([Recipe].self, from: data) {
            print("Test loading saved recipe")
            savedRecipes = recipes
        }
    }
}
