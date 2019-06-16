//
//  StepTableViewCell.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/14/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import UIKit

class StepTableViewCell: UITableViewCell {

    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var stepBullet: UIImageView!
    
    var isComplete = false {
        didSet {
            completeButton.isSelected = isComplete
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        stepLabel.font = UIFont(name: CustomStyles.shared.customFontName, size: 17)
        stepLabel.textColor = UIColor.gray
    }
}
