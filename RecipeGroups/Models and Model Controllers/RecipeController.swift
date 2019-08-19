//
//  RecipeController.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/13/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    static func getDateAndTime() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy_MM_dd_hh_mm_ss"
        let dateString = formatter.string(from: now)
        
        return dateString
    }
}

class RecipeController {
    
    static let shared = RecipeController()
    
    static let recipeDataUpdatedNotification = Notification.Name("RecipeController.recipeDataUpdated")
    
    var recipes: [Recipe] = []
    var savedRecipes: [Recipe] = []
    var likedRecipes: [Recipe] = []
    let baseURL = Secret.shared.baseURL

    func sendRecipe(recipe: Recipe, completion: @escaping () -> ()) {
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
        
        guard let imageData = recipe.image?.jpegData(compressionQuality: 0.5) else { return }
        
        request.httpBody = createBody(parameters: textData, arrayParameters: arrayParameters, boundary: boundary, data: imageData, mimeType: "image/jpg", filename: imageFileName)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                self.processNew(recipe: recipe)
                completion()
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
        guard let email = UserController.shared.user?.email else { return }
        
        for recipe in recipes {
            if !self.recipes.contains(where: { $0.name == recipe.name && ($0.author == recipe.author
                || recipe.isLiked ?? false || $0.author == "thisDevice") }) {
                
                self.recipes.append(recipe)
            }
        }
        
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
    
    func processRecipeIfUserIsNone(recipe: Recipe) {
        self.recipes.insert(recipe, at: 0)
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
            for recipe in recipes {
                loadLocalImage(for: recipe)
            }
        }
    }
    
    func saveLikedRecipe(_ recipe: Recipe) {
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let likedRecipeFileURL = documentsDirectoryURL.appendingPathComponent("likedRecipe").appendingPathExtension("json")
        let jsonEncoder = JSONEncoder()
        likedRecipes.append(recipe)
        saveImage(from: recipe)
        if let data = try? jsonEncoder.encode(likedRecipes) {
            try? data.write(to: likedRecipeFileURL)
        }
    }
    
    func saveUserRecipe(_ recipe: Recipe) {
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let recipeFileURL = documentsDirectoryURL.appendingPathComponent("recipe").appendingPathExtension("json")
        let jsonEncoder = JSONEncoder()
        saveImage(from: recipe)
        savedRecipes.append(recipe)
        if let data = try? jsonEncoder.encode(savedRecipes) {
            try? data.write(to: recipeFileURL)
        }
    }
    
    func loadSavedRecipes() {
        
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let recipeFileURL = documentsDirectoryURL.appendingPathComponent("recipe").appendingPathExtension("json")
        guard let data = try? Data(contentsOf: recipeFileURL) else { return }
        let jsonDecoder = JSONDecoder()
        if let recipes = try? jsonDecoder.decode([Recipe].self, from: data) {
            savedRecipes = recipes
            for recipe in recipes {
                loadLocalImage(for: recipe)
            }
        }
    }
    
    func saveImage(from recipe: Recipe) {
        guard let image = recipe.image else { return }
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = "recipeImage\(Date.getDateAndTime()).jpeg"
        let imageURL = documentsDirectoryURL.appendingPathComponent("\(fileName)")
        guard let data = image.jpegData(compressionQuality: 1.0) else { return }
        
        if !FileManager.default.fileExists(atPath: imageURL.path) {
            do {
                try data.write(to: imageURL)
            } catch {
                print("Error in writing image data")
            }
        }
        
        recipe.localImageName = fileName
    }
    
    func loadLocalImage(for recipe: Recipe) {
        guard let localImageName = recipe.localImageName else { return }
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let recipeImageURL = documentsDirectoryURL.appendingPathComponent(localImageName)
        
        do {
            let imageData = try Data(contentsOf: recipeImageURL)
            recipe.image = UIImage(data: imageData)
        } catch {
            print("Error loading image")
        }
    }
    
    func delete(recipe: Recipe) {
        
        // Delete the locally saved recipe image
        if let localImageName = recipe.localImageName {
            let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let recipeImageURL = documentsDirectoryURL.appendingPathComponent(localImageName)
            
            do {
                try FileManager.default.removeItem(atPath: recipeImageURL.path)
            } catch {
                print("Error removing image file")
            }
        }
        
        // remove the recipe from the savedRecipes array
        savedRecipes.removeAll { $0.name == recipe.name }
        recipes.removeAll { $0.name == recipe.name }
        
        // save the savedRecipes array
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let recipeFileURL = documentsDirectoryURL.appendingPathComponent("recipe").appendingPathExtension("json")
        let jsonEncoder = JSONEncoder()
        if let data = try? jsonEncoder.encode(savedRecipes) {
            try? data.write(to: recipeFileURL)
        }
    }
    
    // Tell the server to delete the recipe
    func deleteRecipeFromServer(recipe recipeNamed: Recipe, completion: @escaping (String) -> ()) {
        guard let user = UserController.shared.user else { return }
        let url = baseURL.appendingPathComponent("delete_recipe")
        let sentData: [String: String] = [
            "email": user.email,
            "recipeName": recipeNamed.name
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
                }
            }
        }
        task.resume()
    }
}
