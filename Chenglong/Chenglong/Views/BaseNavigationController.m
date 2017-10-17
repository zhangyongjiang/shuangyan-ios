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
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UIViewController*)popViewControllerAnimated:(BOOL)animated {
    UIViewController* c = [super popViewControllerAnimated:animated];
    if(c) {
        [SVProgressHUD dismiss];
       [[NSNotificationCenter defaultCenter] removeObserver:c];
    }
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

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
         if(orientation == UIInterfaceOrientationPortrait) {
             NSLog(@"UIInterfaceOrientationPortrait");
             self.navigationBarHidden = NO;
         }
         if(orientation == UIInterfaceOrientationPortraitUpsideDown) {
             NSLog(@"UIInterfaceOrientationPortraitUpsideDown");
             self.navigationBarHidden = NO;
         }
         if(orientation == UIInterfaceOrientationLandscapeLeft) {
             NSLog(@"UIInterfaceOrientationLandscapeLeft");
             self.navigationBarHidden = YES;
         }
         if(orientation == UIInterfaceOrientationLandscapeRight) {
             NSLog(@"UIInterfaceOrientationLandscapeRight");
             self.navigationBarHidden = YES;
         }
         if(orientation == UIInterfaceOrientationUnknown) {
             NSLog(@"UIInterfaceOrientationUnknown");
             self.navigationBarHidden = NO;
         }
         // do whatever
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

- (BOOL)shouldAutorotate {
    //Use this if your root controller is a navigation controller
    return self.visibleViewController.shouldAutorotate;
}

- (NSUInteger)supportedInterfaceOrientations {
    //Navigation Controller
    return self.visibleViewController.supportedInterfaceOrientations;
}
@end
