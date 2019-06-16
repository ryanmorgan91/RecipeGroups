//
//  User.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/16/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import Foundation

class User: Codable {
    
    var name: String
    var email: String
    var recipes: [Recipe]?
    var groups: [Group]?
    
    init(name: String, email: String) {
        self.name = name
        self.email = email
    }
}
