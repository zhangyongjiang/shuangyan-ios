//
//  ProfileViewController.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 7/28/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "ProfileNavigationController.h"
#import "ProfileViewController.h"

@interface ProfileNavigationController ()

@end

@implementation ProfileNavigationController

-(id)init {
    self = [super init];
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"设置" image:[[UIImage imageNamed:@"tab_btn_me_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tab_btn_me_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    self.tabBarItem.imageInsets = UIEdgeInsetsMake(-4, 0, 4, 0);
    
    self.viewControllers = @[[ProfileViewController new]];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
