//
//  Recipe.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/12/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import Foundation
import UIKit

final class Recipe: Codable {
    var name: String
    var image: UIImage?
    var imageURL: URL?
    var cookTime: CookTime
    var cookingDifficulty: Difficulty
    var category: Category
    var description: String
    var ingredients: [String]
    var steps: [String]
    var author: String
    
    enum Difficulty: String, CaseIterable, Codable {
        case easy = "Easy"
        case medium = "Medium"
        case hard = "Hard"
    }
    
    enum Category: String, CaseIterable, Codable {
        case italian = "Italian"
        case greek = "Greek"
        case french = "French"
        case american = "American"
        case thai = "Thai"
        case chinese = "Chinese"
        case dessert = "Dessert"
        case other = "Other"
    }
    
    enum CookTime: String, CaseIterable, Codable {
        case fifteen = "15 mins"
        case thirty = "30 mins"
        case fortyFive = "45 mins"
        case sixty = "1 hr"
        case seventyFive = "1 hr 15 mins"
        case ninety = "1 hr 30 mins"
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "title"
        case imageURL = "image_url"
        case cookTime
        case cookingDifficulty = "difficulty"
        case category
        case description
        case ingredients
        case steps
        case author
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: CodingKeys.name)
        self.cookTime = try container.decode(CookTime.self, forKey: CodingKeys.cookTime)
        self.cookingDifficulty = try container.decode(Difficulty.self, forKey: CodingKeys.cookingDifficulty)
        self.category = try container.decode(Category.self, forKey: CodingKeys.category)
        self.description = try container.decode(String.self, forKey: CodingKeys.description)
        self.ingredients = try container.decode([String].self, forKey: CodingKeys.ingredients)
        self.steps = try container.decode([String].self, forKey: CodingKeys.steps)
        self.imageURL = try container.decode(URL.self, forKey: CodingKeys.imageURL)
        self.author = try container.decode(String.self, forKey: CodingKeys.author)
    }
    
    init(name: String, image: UIImage, cookTime: CookTime, cookingDifficulty: Difficulty, category: Category, description: String, ingredients: [String], steps: [String], author: String) {
        self.name = name
        self.image = image
        self.cookTime = cookTime
        self.cookingDifficulty = cookingDifficulty
        self.category = category
        self.description = description
        self.ingredients = ingredients
        self.steps = steps
        self.author = author
    }
    
    static func loadSampleRecipes() -> [Recipe] {
        let macarons = Recipe(name: "Macarons", image: UIImage(named: "Macarons")!, cookTime: .sixty, cookingDifficulty: .hard, category: .dessert, description: "Lovely french macarons", ingredients: ["Ingredient 1"], steps: ["Step 1", "Step 2", "Step 3"], author: "johnsmith@example.com")
        let raspberryCheesecake = Recipe(name: "Raspberry Cheesecake", image: UIImage(named: "RaspberryCheesecake")!, cookTime: .sixty, cookingDifficulty: .medium, category: .dessert, description: "Classic raspberry cheesecake", ingredients: ["Ingredient 1"], steps: ["Step 1"], author: "johnsmith@example.com")
        let cherryPie = Recipe(name: "Cherry Pie", image: UIImage(named: "CherryPie")!, cookTime: .seventyFive, cookingDifficulty: .easy, category: .dessert, description: "Home-cooked apple pie!", ingredients: ["Ingredient 1"], steps: ["Step 1"], author: "johnsmith@example.com")
        let tiramisu = Recipe(name: "Tiramisu", image: UIImage(named: "Tiramisu")!, cookTime: .ninety, cookingDifficulty: .hard, category: .dessert, description: "Italian tiramisu", ingredients: ["Ingredient 1"], steps: ["Step 1"], author: "johnsmith@example.com")
        let birthdayCakeFudge = Recipe(name: "Birthday Cake Fudge", image: UIImage(named: "BirthdayCakeFudge")!, cookTime: .fortyFive, cookingDifficulty: .easy, category: .dessert, description: "An interesting take on fudge", ingredients: ["Ingredient 1"], steps: ["Step 1"], author: "johnsmith@example.com")
        
        return [macarons, raspberryCheesecake, cherryPie, tiramisu, birthdayCakeFudge]
    }
    
    
}
