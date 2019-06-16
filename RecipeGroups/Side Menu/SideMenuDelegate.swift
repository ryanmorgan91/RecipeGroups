//
//  SideMenuDelegate.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/16/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import Foundation

// Protocol to notify delegate which menu item was tapped
protocol SideMenuDelegate: AnyObject {
    func userTapped(menuButton: String)
}
