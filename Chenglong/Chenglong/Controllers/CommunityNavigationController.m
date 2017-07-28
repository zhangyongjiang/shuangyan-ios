//
//  CommunityNavigationController.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 7/28/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "CommunityNavigationController.h"
#import "OnlineSearchListViewController.h"

@interface CommunityNavigationController ()

@end

@implementation CommunityNavigationController

-(id)init {
    self = [super init];
    
    self.viewControllers = [NSArray arrayWithObject:[OnlineSearchListViewController new]];
    
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"共享" image:[[UIImage imageNamed:@"tab_btn_community_norl"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tab_btn_community_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    self.tabBarItem.imageInsets = UIEdgeInsetsMake(-4, 0, 4, 0);
    
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
