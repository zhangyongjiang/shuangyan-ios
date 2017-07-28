//
//  MyFileNavigationViewController.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 7/28/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "MyFileNavigationController.h"
#import "FileListViewController.h"

@interface MyFileNavigationController ()

@end

@implementation MyFileNavigationController

-(id)init {
    self = [super init];
    
    FileListViewController* file = [[FileListViewController alloc] init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    file.filePath = documentsPath;
    self.viewControllers = [NSArray arrayWithObject:file];
    
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[[UIImage imageNamed:@"tab_btn_file_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tab_btn_file_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
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
