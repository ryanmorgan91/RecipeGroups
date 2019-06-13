//
//  MyGroupsTableViewCell.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/17/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import UIKit

class MyGroupsTableViewCell: UITableViewCell {

    @IBOutlet weak var shadowLayer: UIView!
    @IBOutlet weak var backgroundLayer: UIView!
    @IBOutlet weak var groupLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell() {
        backgroundLayer.backgroundColor = CustomStyles.shared.customPink
        groupLabel.textColor = .white
        groupLabel.font = UIFont(name: CustomStyles.shared.customFontNameWide, size: 20)
    }

}
