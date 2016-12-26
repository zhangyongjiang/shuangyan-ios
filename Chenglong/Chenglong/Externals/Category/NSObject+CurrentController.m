//
//  NSObject+CurrentController.m
//  Kaishi
//
//  Created by wangyaochang on 2016/11/29.
//  Copyright © 2016年 BCGDV. All rights reserved.
//

#import "NSObject+CurrentController.h"
#import "MainTabBarController.h"

@implementation NSObject (CurrentController)

- (UINavigationController *)getCurrentNavController
{
    UIViewController * c = [self getPresentedViewController];
    UIViewController *n;
    if ([c isKindOfClass:[UINavigationController class]])
    {
        UINavigationController * nav = (UINavigationController *)c;
        n = [nav.viewControllers lastObject];
        //循环一下
        while (n.presentedViewController) {
            c = n.presentedViewController;
            if ([c isKindOfClass:[UINavigationController class]]) {
                UINavigationController * nav1 = (UINavigationController *)c;
                n = [nav1.viewControllers lastObject];
            }else{
                n = c;
            }
        }
        
        if (![n isKindOfClass:[MainTabBarController class]])
        {
            return n.navigationController;
        }
    }
    else
    {
        n = c;
    }
    MainTabBarController * router = (MainTabBarController *)n;
    UINavigationController * nav = [router selectedViewController];
    UIViewController * cc = [nav topViewController];
    return cc.navigationController;
}

- (UIViewController *)getPresentedViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController)
    {
        topVC = topVC.presentedViewController;
    }
    
    return topVC;
}


@end
