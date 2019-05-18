//
//  Group.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/17/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import Foundation

class Group {
    var name: String
    // To Do: Check if password is needed here and whether I need to encrypt it
    var password: String
    var groupCreator: User?
    var groupMembers: [User]?
    var recipes: [Recipe]
    
    init(name: String, password: String, recipes: [Recipe]) {
        self.name = name
        self.password = password
        self.recipes = recipes
    }
    
    static func loadSampleGroups() -> [Group] {
        let group = Group(name: "Morgan Family", password: "12345", recipes: Recipe.loadSampleRecipes())
        return [group]
    }
}
