//
//  PlayListNavViewController.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 10/17/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "PlayListNavViewController.h"
#import "PlayViewController.h"

@interface PlayListNavViewController ()

@end

@implementation PlayListNavViewController

-(id)init {
    self = [super init];
    
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"播放" image:[[UIImage imageNamed:@"tab_btn_city_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tab_btn_city_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    self.tabBarItem.imageInsets = UIEdgeInsetsMake(-4, 0, 4, 0);
    
    self.viewControllers = @[[PlayViewController new]];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
