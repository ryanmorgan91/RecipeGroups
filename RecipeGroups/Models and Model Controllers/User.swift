//
//  User.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/16/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import Foundation

class User {
    
    var name: String
    var email: String
    var recipes: [Recipe]
    var groups: [Group]
    
    init(name: String, email: String, recipes: [Recipe], groups: [Group]) {
        self.name = name
        self.email = email
        self.recipes = recipes
        self.groups = groups
    }
}
