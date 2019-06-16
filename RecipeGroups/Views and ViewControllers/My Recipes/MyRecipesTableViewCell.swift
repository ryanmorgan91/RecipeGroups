//
//  MyRecipesTableViewCell.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/17/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import UIKit

class MyRecipesTableViewCell: UITableViewCell {

    @IBOutlet weak var shadowLayer: ShadowCellView!
    @IBOutlet weak var mainBackground: CellBackgroundView!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        recipeLabel.font = UIFont(name: CustomStyles.shared.customFontName, size: 17)
    }
}
