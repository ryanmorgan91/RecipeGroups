//
//  Extensions.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/15/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func displayActivityIndicator(onView: UIView) -> UIView {
        let backgroundView = UIView.init(frame: onView.bounds)
        backgroundView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let activityIndicator = UIActivityIndicatorView.init(style: .white)
        activityIndicator.startAnimating()
        activityIndicator.center = backgroundView.center
        
        DispatchQueue.main.async {
            backgroundView.addSubview(activityIndicator)
            onView.addSubview(backgroundView)
        }
        
        return backgroundView
    }
    
    func removeActivityIndicator(activityBackgroundView: UIView) {
        DispatchQueue.main.async {
            activityBackgroundView.removeFromSuperview()
        }
    }
}
