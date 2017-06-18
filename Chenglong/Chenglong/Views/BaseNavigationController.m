//
//  BaseNavigationController.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/17/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIViewController *lastVC = nil;
    if (self.viewControllers.count > 0) {
        lastVC = self.viewControllers[self.viewControllers.count - 1];
    }
    if (lastVC != nil) {
        lastVC.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:YES];
    if (self.viewControllers.count == 2) {
        lastVC.hidesBottomBarWhenPushed = NO;
    }
}
@end
