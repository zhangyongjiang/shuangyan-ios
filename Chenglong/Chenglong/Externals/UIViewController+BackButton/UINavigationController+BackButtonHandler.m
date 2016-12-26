//
//  UINavigationController+BackButtonHandler.m
//  Fadein
//
//  Created by jijunyuan on 15/5/21.
//  Copyright (c) 2015年 Arceus. All rights reserved.
//

#import "UINavigationController+BackButtonHandler.h"

@implementation UINavigationController (BackButtonHandler)

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem*)item {
    
    if([self.viewControllers count] < [navigationBar.items count])
    {
        return YES;
    }
    
    BOOL shouldPop = YES;
    UIViewController* vc = [self topViewController];
    if([vc respondsToSelector:@selector(navigationShouldPopOnBackButton)]) {
        shouldPop = [vc navigationShouldPopOnBackButton];
    }
    
    if(shouldPop)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popViewControllerAnimated:YES];
        });
    }
    else
    {
        for(UIView *subview in [navigationBar subviews]) {
            if(subview.alpha < 1.)
            {
                [UIView animateWithDuration:.25 animations:^{
                    subview.alpha = 1.;
                }];
            }
        }
    }
    
    return NO;
}

@end
