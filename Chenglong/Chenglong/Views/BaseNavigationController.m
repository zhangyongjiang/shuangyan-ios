//
//  BaseNavigationController.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/17/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "BaseNavigationController.h"
#import "BaseViewController.h"

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


-(UIViewController*)popViewControllerAnimated:(BOOL)animated {
    UIViewController* c = [super popViewControllerAnimated:animated];
    if(c)
       [[NSNotificationCenter defaultCenter] removeObserver:c];
    return c;
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    for (UIViewController* c in self.viewControllers) {
        if([c isKindOfClass:[BaseViewController class]]) {
            BaseViewController* bvc = c;
            if([bvc isSameViewController:viewController]) {
                [self popToViewController:c animated:YES];
                return;
            }
        }
    }
    [super pushViewController:viewController animated:animated];
}
@end
