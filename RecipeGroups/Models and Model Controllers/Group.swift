//
//  Group.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/17/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import Foundation

final class Group: Codable {
    
    // Does not store password in the app.  Only stores as encrypted in database.
    // We never have access to users passwords
    var name: String
    var creator: String
    var members: [String]
    var password: String?
    
    init(name: String, creator: String, members: [String], password: String? = nil) {
        self.name = name
        self.creator = creator
        self.members = members
        self.password = password
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case creator
        case members
        case password
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: CodingKeys.name)
        self.creator = try container.decode(String.self, forKey: CodingKeys.creator)
        self.members = try container.decode([String].self, forKey: CodingKeys.members)
        self.password = try? container.decode(String.self, forKey: CodingKeys.password)
    }
    
    // Sample groups for development and testing
    static func loadSampleGroups() -> [Group] {
        let group = Group(name: "Sample Group", creator: "johnsmith@example.com", members: ["johnsmith@example.com"])
        return [group]
    }
}
