//
//  Recipe.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/12/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import Foundation
import UIKit

class Recipe {
    var name: String
    var image: UIImage
    var cookTime: TimeInterval
    var cookingDifficulty: Difficulty
    var category: Category
    var description: String
    
    enum Difficulty: String {
        case easy = "Easy"
        case medium = "Medium"
        case hard = "Hard"
    }
    
    enum Category: String {
        case italian = "Italian"
        case greek = "Greek"
        case french = "French"
        case american = "American"
        case thai = "Thai"
        case chinese = "Chinese"
        case dessert = "Dessert"
        case other = "Other"
        
    }
    
    init(name: String, image: UIImage, cookTime: TimeInterval, cookingDifficulty: Difficulty, category: Category, description: String) {
        self.name = name
        self.image = image
        self.cookTime = cookTime
        self.cookingDifficulty = cookingDifficulty
        self.category = category
        self.description = description
    }
    
    static func loadSampleRecipes() -> [Recipe] {
        let macarons = Recipe(name: "Macarons", image: UIImage(named: "Macarons")!, cookTime: (60*60), cookingDifficulty: .hard, category: .dessert, description: "Lovely french macarons")
        let raspberryCheesecake = Recipe(name: "Raspberry Cheesecake", image: UIImage(named: "RaspberryCheesecake")!, cookTime: (60*60), cookingDifficulty: .medium, category: .dessert, description: "Classic raspberry cheesecake")
        let cherryPie = Recipe(name: "Cherry Pie", image: UIImage(named: "CherryPie")!, cookTime: (80*60), cookingDifficulty: .easy, category: .dessert, description: "Home-cooked apple pie!")
        let tiramisu = Recipe(name: "Tiramisu", image: UIImage(named: "Tiramisu")!, cookTime: (120*60), cookingDifficulty: .hard, category: .dessert, description: "Italian tiramisu")
        let birthdayCakeFudge = Recipe(name: "Birthday Cake Fudge", image: UIImage(named: "BirthdayCakeFudge")!, cookTime: (45*60), cookingDifficulty: .easy, category: .dessert, description: "An interesting take on fudge")
        
        return [macarons, raspberryCheesecake, cherryPie, tiramisu, birthdayCakeFudge]
    }
    
    
}
