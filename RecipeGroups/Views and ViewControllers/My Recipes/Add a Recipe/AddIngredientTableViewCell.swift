//
//  IngredientTableViewCell.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/21/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import UIKit

class AddIngredientTableViewCell: UITableViewCell {

    @IBOutlet weak var stepBullet: UIImageView!
    @IBOutlet weak var ingredientTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
