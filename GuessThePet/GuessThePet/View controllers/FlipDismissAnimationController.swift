//
//  FlipDismissAnimationController.swift
//  GuessThePet
//
//  Created by 李潇 on 16/1/14.
//  Copyright © 2016年 Razeware LLC. All rights reserved.
//

import UIKit

class FlipDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    var destinatonFrame = CGRect.zero

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let containerView:AnyObject = transitionContext.containerView,
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
                return
        }

        _ = transitionContext.initialFrame(for: fromVC)
        let finalFrame = destinatonFrame

        let snapshot = fromVC.view.snapshotView(afterScreenUpdates: false)
        snapshot?.layer.cornerRadius = 25
        snapshot?.layer.masksToBounds = true

        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot!)
        fromVC.view.isHidden = true

        AnimationHelper.perspectiveTransformForContainerView(containerView as! UIView)

        toVC.view.layer.transform = AnimationHelper.yRotation(-M_PI_2)

        let duration = transitionDuration(using: transitionContext)

        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubic, animations: { () -> Void in
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/3, animations: { () -> Void in
                snapshot?.frame = finalFrame
            })
            UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3, animations: { () -> Void in
                snapshot!.layer.transform = AnimationHelper.yRotation(M_PI_2)
            })
            UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3, animations: { () -> Void in
                toVC.view.layer.transform = AnimationHelper.yRotation(0)
            })
            }) { (_) -> Void in
                fromVC.view.isHidden = false
                snapshot?.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
