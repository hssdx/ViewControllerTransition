//
//  FlipPresentAnimationController.swift
//  GuessThePet
//
//  Created by 李潇 on 16/1/14.
//  Copyright © 2016年 Razeware LLC. All rights reserved.
//

import UIKit

class FlipPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    var originFrame = CGRect.zero

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let containerView:AnyObject = transitionContext.containerView,
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
                return
        }

        let initialFrame = originFrame
        let finalFrame = transitionContext.finalFrame(for: toVC)

        let snapshot = toVC.view.snapshotView(afterScreenUpdates: true)
        snapshot?.frame = initialFrame
        snapshot?.layer.cornerRadius = 25
        snapshot?.layer.masksToBounds = true

        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot!)
        toVC.view.isHidden = true

        AnimationHelper.perspectiveTransformForContainerView(containerView as! UIView)
        snapshot?.layer.transform = AnimationHelper.yRotation(M_PI_2)

        let duration = transitionDuration(using: transitionContext)

        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubic, animations: { () -> Void in
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/3, animations: { () -> Void in
                fromVC.view.layer.transform = AnimationHelper.yRotation(-M_PI_2)
            })

            UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3, animations: { () -> Void in
                snapshot!.layer.transform = AnimationHelper.yRotation(0.0)
            })

            UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3, animations: { () -> Void in
                snapshot?.frame = finalFrame
            })
            }) { (_) -> Void in
                toVC.view.isHidden = false
                fromVC.view.layer.transform = AnimationHelper.yRotation(0.0)
                snapshot?.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
