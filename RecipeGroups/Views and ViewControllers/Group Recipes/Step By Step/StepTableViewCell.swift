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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
