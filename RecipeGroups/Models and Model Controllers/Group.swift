//
//  Group.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/17/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import Foundation

final class Group: Codable {
    var name: String
    // To Do: Check if password is needed here and whether I need to encrypt it
//    var password: String
    var creator: String
    var members: [String]
//    var recipes: [Recipe]
    
    init(name: String, creator: String, members: [String]) {
        self.name = name
        self.creator = creator
        self.members = members
//        self.password = password
//        self.recipes = recipes
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case creator
        case members
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: CodingKeys.name)
        self.creator = try container.decode(String.self, forKey: CodingKeys.creator)
        self.members = try container.decode([String].self, forKey: CodingKeys.members)
    }
    
    static func loadSampleGroups() -> [Group] {
        let group = Group(name: "Sample Group", creator: "johnsmith@example.com", members: ["johnsmith@example.com"])
        return [group]
    }
}
