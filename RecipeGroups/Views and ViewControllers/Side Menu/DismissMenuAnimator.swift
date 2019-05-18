//
//  DismissMenuAnimator.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/16/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import UIKit

class DismissMenuAnimator: NSObject {
    
}

extension DismissMenuAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else { return }
        guard let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else { return }
        
        let containerView = transitionContext.containerView
        let snapShot = containerView.viewWithTag(MenuHelper.snapshotNumber)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            snapShot?.frame = CGRect(origin: CGPoint.zero, size: UIScreen.main.bounds.size)
        }) { (_) in
            let didTransitionComplete = !transitionContext.transitionWasCancelled
            if didTransitionComplete {
                containerView.insertSubview(toViewController.view, aboveSubview: fromViewController.view)
                snapShot?.removeFromSuperview()
            }
            transitionContext.completeTransition(didTransitionComplete)
        }
    }
}
