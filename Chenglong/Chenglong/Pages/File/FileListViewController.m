//
//  FileListViewController.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "FileListViewController.h"

@interface FileListViewController ()

@property(strong, nonatomic) FileListPage* page;

@end

@implementation FileListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createPage];

    if(self.currentDirId == NULL)
        self.navigationItem.title = @"我的";
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[[UIImage imageNamed:@"tab_btn_file_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tab_btn_file_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    self.tabBarItem.imageInsets = UIEdgeInsetsMake(-4, 0, 4, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)createPage {
    self.page = [[FileListPage alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.page];
    [self refreshPage];
}

-(void)refreshPage {
    [CourseApi CourseAPI_ListUserCourses:NULL currentDirId:self.currentDirId page:0 onSuccess:^(CourseDetailsList *resp) {
        if(resp.courseDetails) {
            self.navigationItem.title = resp.courseDetails.course.title;
        }
        [self.page setCourseDetailsList:resp];
    } onError:^(APIError *err) {
        
    }];
}

@end
