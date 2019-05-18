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
    
    enum Difficulty: String {
        case easy = "Easy"
        case medium = "Medium"
        case hard = "Hard"
    }
    
    init(name: String, image: UIImage, cookTime: TimeInterval, cookingDifficulty: Difficulty) {
        self.name = name
        self.image = image
        self.cookTime = cookTime
        self.cookingDifficulty = cookingDifficulty
    }
    
    static func loadSampleRecipes() -> [Recipe] {
        let macarons = Recipe(name: "Macarons", image: UIImage(named: "Macarons")!, cookTime: (60*60), cookingDifficulty: .hard)
        let raspberryCheesecake = Recipe(name: "Raspberry Cheesecake", image: UIImage(named: "RaspberryCheesecake")!, cookTime: (60*60), cookingDifficulty: .medium)
        let cherryPie = Recipe(name: "Cherry Pie", image: UIImage(named: "CherryPie")!, cookTime: (80*60), cookingDifficulty: .easy)
        let tiramisu = Recipe(name: "Tiramisu", image: UIImage(named: "Tiramisu")!, cookTime: (120*60), cookingDifficulty: .hard)
        let birthdayCakeFudge = Recipe(name: "Birthday Cake Fudge", image: UIImage(named: "BirthdayCakeFudge")!, cookTime: (45*60), cookingDifficulty: .easy)
        
        return [macarons, raspberryCheesecake, cherryPie, tiramisu, birthdayCakeFudge]
    }
    
    
}
