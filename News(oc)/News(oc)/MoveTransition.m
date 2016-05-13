//
//  MoveTransition.m
//  News(oc)
//
//  Created by yunyi3g5 on 16/5/12.
//  Copyright © 2016年 founder. All rights reserved.
//

#import "MoveTransition.h"

@implementation MoveTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *container = [transitionContext containerView];
    [container addSubview:toVc.view];
    [container addSubview:fromVc.view];
    
    [UIView animateWithDuration:[self transitionDuration:nil] delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        toVc.view.alpha = 1;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}
@end
