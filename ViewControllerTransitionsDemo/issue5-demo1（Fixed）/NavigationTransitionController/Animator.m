//
//  Animator.m
//  NavigationTransitionTest
//
//  Created by Chris Eidhof on 9/27/13.
//  Copyright (c) 2013 Chris Eidhof. All rights reserved.
//

#import "Animator.h"

@implementation Animator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 1;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [[transitionContext containerView] addSubview:toViewController.view];
    //toViewController.view.alpha = 0;
    toViewController.view.transform = CGAffineTransformMakeTranslation(toViewController.view.bounds.size.width, 0);
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        fromViewController.view.transform = CGAffineTransformMakeTranslation(-fromViewController.view.bounds.size.width, 0);//CGAffineTransformMakeScale(0.1, 0.1);
        toViewController.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        fromViewController.view.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
