//
//  GroupMemberTableViewCell.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 6/2/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import UIKit

class GroupMemberTableViewCell: UITableViewCell {

    @IBOutlet weak var memberImage: UIImageView!
    @IBOutlet weak var memberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func setupCell() {
        let customColors = CustomColors()
        memberImage.tintColor = customColors.customPink
    }
    
}
