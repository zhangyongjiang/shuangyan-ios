//
//  CommunityViewController.m
//  Chenglong
//
//  Created by wangyaochang on 2016/12/26.
//  Copyright © 2016年 Chenglong. All rights reserved.
//

#import "CommunityViewController.h"

@interface CommunityViewController ()

@end

@implementation CommunityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"社区" image:[[UIImage imageNamed:@"tab_btn_community_norl"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tab_btn_community_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    self.tabBarItem.imageInsets = UIEdgeInsetsMake(-4, 0, 4, 0);
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"社区";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
