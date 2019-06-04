//
//  IngredientsTableViewCell.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/17/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import UIKit

class IngredientsTableViewCell: UITableViewCell {

    @IBOutlet weak var ingredientLabel: UILabel!
    @IBOutlet weak var ingredientBullet: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let customColors = CustomColors()
        ingredientBullet.tintColor = customColors.customBlue
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}