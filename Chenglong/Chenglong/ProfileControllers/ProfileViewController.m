//
//  ProfileViewController.m
//  Chenglong
//
//  Created by wangyaochang on 2016/12/26.
//  Copyright © 2016年 Chenglong. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[[UIImage imageNamed:@"tab_btn_me_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tab_btn_me_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    self.tabBarItem.imageInsets = UIEdgeInsetsMake(-4, 0, 4, 0);
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的";
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor kaishiColor:UIColorTypeThemeSelected];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(100, 200, 200, 45);
    [btn setTitle:@"退出登录" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(loginOut:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginOut:(UIButton *)btn
{
    AppDelegate *app = kAppDelegate;
    [app logout];
}

@end
