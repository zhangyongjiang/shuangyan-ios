//
//  CourseTreeViewController.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 7/26/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "CourseTreeViewController.h"

@interface CourseTreeViewController ()


@end

@implementation CourseTreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = [[CourseTreePage alloc] initWithFrame:self.view.bounds];
    self.page.height -= 108;
    
    [self.page.refreshControl addTarget:self action:@selector(refreshPage) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.page];
    [self refreshPage];
}

-(void)refreshPage {
    [CourseApi CourseAPI_ListUserCourseTree:self.userId onSuccess:^(CourseDetails *resp) {
        CourseDetails* root = [CourseDetails new];
        root.course = [Course new];
        root.course.isDir = [NSNumber numberWithInteger:1];
        root.course.title = @"我的文件";
        root.items = resp.items;
        CourseDetails* container = [CourseDetails new];
        container.items = [NSMutableArray arrayWithObject:root];
        self.page.courseDetails = container;
        [self.page.refreshControl endRefreshing];
    } onError:^(APIError *err) {
        ALERT_VIEW_WITH_TITLE(err.errorCode, err.errorMsg);
        [self.page.refreshControl endRefreshing];
    }];
}
@end
