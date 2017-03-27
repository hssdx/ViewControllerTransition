//
//  SwipeInteractionController.swift
//  GuessThePet
//
//  Created by 李潇 on 16/1/14.
//  Copyright © 2016年 Razeware LLC. All rights reserved.
//

import UIKit

class SwipeInteractionController: UIPercentDrivenInteractiveTransition {
    var interactionInProgress = false
    fileprivate var shouldCompleteTransition = false
    fileprivate weak var viewController: UIViewController!

    func wireToViewController(_ viewController: UIViewController!) {
        self.viewController = viewController
        prepareGestureRecognizerInView(viewController.view)
    }

    fileprivate func prepareGestureRecognizerInView(_ view: UIView) {
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(SwipeInteractionController.handleGesture(_:)))
        gesture.edges = UIRectEdge.left
        view.addGestureRecognizer(gesture)
    }

    func handleGesture(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        var progress = translation.x / 200
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))

        switch gestureRecognizer.state {
        case .began:
            interactionInProgress = true
            viewController.dismiss(animated: true, completion: nil)

        case .changed:
            shouldCompleteTransition = progress > 0.5
            update(progress)

        case .cancelled:
            interactionInProgress = false
            cancel()

        case .ended:
            interactionInProgress = false

            if !shouldCompleteTransition {
                cancel()
            } else {
                finish()
            }

        default:
            print("Unsuppported")
        }
    }
}
