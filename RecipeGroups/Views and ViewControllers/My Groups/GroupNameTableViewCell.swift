//
//  GroupNameTableViewCell.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 6/2/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import UIKit

class GroupNameTableViewCell: UITableViewCell {

    
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setupCell() {
        groupImage.tintColor = CustomStyles.shared.customPink
    }

}
