//
//  GroupPasswordTableViewCell.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 6/18/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import UIKit

class GroupPasswordTableViewCell: UITableViewCell {

    @IBOutlet weak var passwordIcon: UIImageView!
    @IBOutlet weak var passwordLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell() {
        passwordIcon.tintColor = CustomStyles.shared.customPink
        passwordLabel.font = UIFont(name: CustomStyles.shared.customFontName, size: 17)
    }

}
