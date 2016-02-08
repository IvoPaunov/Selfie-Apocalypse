//
//  TransitionManager.swift
//  Selfie apocalypse
//
//  Created by Ivko on 2/8/16.
//  Copyright © 2016 Ivo Paounov. All rights reserved.
//

import UIKit

class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate  {
    
    var toLeft = true

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

        let container = transitionContext.containerView()
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
     
        let offScreenRight = CGAffineTransformMakeTranslation(container!.frame.width, 0)
        let offScreenLeft = CGAffineTransformMakeTranslation(-container!.frame.width, 0)
   
        toView.transform = self.toLeft ? offScreenRight : offScreenLeft

        container!.addSubview(toView)
        container!.addSubview(fromView)

        let duration = self.transitionDuration(transitionContext)

        UIView.animateWithDuration(duration,
            delay: 0.0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.8,
            options: UIViewAnimationOptions.CurveEaseIn,
            animations: {
            
            fromView.transform = self.toLeft ? offScreenLeft : offScreenRight
            toView.transform = CGAffineTransformIdentity
            
            }, completion: { finished in
            
                transitionContext.completeTransition(true)
        })
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
   
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}
