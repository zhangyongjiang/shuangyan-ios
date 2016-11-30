//
//  BaseNaviController.m
//  Shepherd
//
//  Created by Kevin Zhang (BCG DV) on 11/16/16.
//  Copyright © 2016 BCGDV. All rights reserved.
//

#import "BaseNaviController.h"

@implementation BaseNaviController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationBar.tintColor = [UIColor mainColor];
    self.navigationBar.barTintColor = [UIColor mainColor];
    //    [self.navigationBar setBackgroundImage:[UIImage new]
    //                                      forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
//    self.navigationBar.translucent = YES;
//    self.navigationBar.backgroundColor = [UIColor mainColor];
    
    
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor whiteColor],
                                               NSForegroundColorAttributeName,
                                               [UIFont fontWithName:@"Arial" size:20.0],
                                               NSFontAttributeName,
                                               nil];
    [self.navigationBar setTitleTextAttributes:navbarTitleTextAttributes];
    
}

-(void)setTransparentTitleBar {
    [self.navigationBar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
    self.navigationBar.translucent = YES;
}
@end
