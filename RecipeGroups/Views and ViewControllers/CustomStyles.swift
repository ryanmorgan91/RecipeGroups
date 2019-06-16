//
//  CustomStyles.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/13/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import Foundation
import UIKit

// This class makes it easily to make global changes to stylistic aspects of the app
class CustomStyles {
    static let shared = CustomStyles()
    
    let customPink = UIColor(red: 237/255, green: 107/255, blue: 156/255, alpha: 1.0)
    let customGray = UIColor(red: 224/255, green: 220/255, blue: 220/255, alpha: 1.0)
    let customBlue = UIColor(red: 113/255, green: 195/255, blue: 245/255, alpha: 1.0)
    
    let customFontName = "MarkerFelt-Thin"
    let customFontNameWide = "MarkerFelt-Wide"
}
