//
//  NavigationControllerDelegate.m
//  NavigationTransitionController
//
//  Created by Chris Eidhof on 09.10.13.
//  Copyright (c) 2013 Chris Eidhof. All rights reserved.
//

#import "NavigationControllerDelegate.h"
#import "InteractiveTransition.h"
#import "Animator.h"

static NSString * PushSegueIdentifier = @"push segue identifier";

@interface NavigationControllerDelegate ()

@property (weak, nonatomic) IBOutlet UINavigationController *navigationController;
@property (strong, nonatomic) Animator* animator;
@property (strong, nonatomic) UIPercentDrivenInteractiveTransition* interactionController;
@property (strong, nonatomic) InteractiveTransition *transition;

@end

@implementation NavigationControllerDelegate

- (void)awakeFromNib
{
    UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.navigationController.view addGestureRecognizer:panRecognizer];
    self.animator = [Animator new];
    self.transition = [InteractiveTransition new];
    [super awakeFromNib];
}

//- (UIPercentDrivenInteractiveTransition *)interactionController {
//    return self.transition;
//}

- (void)pan:(UIPanGestureRecognizer*)recognizer
{
    UIView* view = self.navigationController.view;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint location = [recognizer locationInView:view];
        if (location.x > CGRectGetMidX(view.bounds) && self.navigationController.viewControllers.count == 1){
            self.interactionController = [UIPercentDrivenInteractiveTransition new];
            [self.navigationController.visibleViewController performSegueWithIdentifier:PushSegueIdentifier sender:self];
        } else if (location.x < CGRectGetMidX(view.bounds) && self.navigationController.viewControllers.count > 1) {
            self.interactionController = [UIPercentDrivenInteractiveTransition new];
            [self.navigationController popViewControllerAnimated:YES];
            
            //[self.navigationController.visibleViewController performSegueWithIdentifier:PushSegueIdentifier sender:self];
        }
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:view];
        // fabs() 求浮点数的绝对值
        if (self.navigationController.viewControllers.count == 1) {
            CGFloat d = fabs(translation.x / CGRectGetWidth(view.bounds));
            [self.interactionController updateInteractiveTransition:d];
        } else {
            CGFloat d = fabs(translation.x / CGRectGetWidth(view.bounds));
            [self.interactionController updateInteractiveTransition:d];
        }
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self.interactionController finishInteractiveTransition];
        self.interactionController = nil;
    }
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush) {
        return self.animator;
    } else if (operation == UINavigationControllerOperationPop) {
        return self.animator;
    }
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return self.interactionController;
}




@end
