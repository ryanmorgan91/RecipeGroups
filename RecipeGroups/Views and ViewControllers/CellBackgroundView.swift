//
//  CellBackgroundView.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/17/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import UIKit

class CellBackgroundView: UIView {
    
    override var bounds: CGRect {
        didSet {
            setupBackgroundView()
        }
    }

    private func setupBackgroundView() {
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
    }

}
