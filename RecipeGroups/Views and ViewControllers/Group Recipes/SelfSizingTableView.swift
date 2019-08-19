//
//  SelfSizingTableView.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 8/17/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import UIKit

class SelfSizingTableView: UITableView {

    var maxHeight: CGFloat = 500
    
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }

    override var intrinsicContentSize: CGSize {
        let height = min(contentSize.height, maxHeight)
        return CGSize(width: contentSize.width, height: height)
    }
}
