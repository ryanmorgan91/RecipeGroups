//
//  RecipeTableViewCell.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/12/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeLabel: UILabel!
    @IBOutlet weak var shadowLayer: UIView!
    @IBOutlet weak var mainBackground: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        recipeLabel.font = UIFont(name: CustomStyles.shared.customFontName, size: 17)
    }
}

