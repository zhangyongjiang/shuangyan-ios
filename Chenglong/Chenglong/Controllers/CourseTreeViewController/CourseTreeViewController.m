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
    CGRect rect = self.view.bounds;
    rect.size.height = rect.size.height - 108;
    self.page = [[CourseTreePage alloc] initWithFrame:rect];
    if(self.userId == nil || [Global isLoginUser:self.userId]){
        self.title = @"我的文件";
    }
    else {
        self.title = @"用户文件";
    }
    
    [self.page.refreshControl addTarget:self action:@selector(refreshPage) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.page];
    [self refreshPage];
}

-(void)refreshPage {
    [CourseApi CourseAPI_ListUserCourseTree:self.userId onSuccess:^(CourseDetails *resp) {
        resp.course = [Course new];
        resp.course.isDir = [NSNumber numberWithInteger:1];
        
        if(self.userId == NULL || [Global isLoginUser:self.userId])
            resp.course.title = [NSString stringWithFormat:@"我的文件"];
        else
            resp.course.title = [NSString stringWithFormat:@"%@的文件", resp.user.name];
        
        CourseDetails* container = [CourseDetails new];
        container.items = [NSMutableArray arrayWithObject:resp];
        self.page.courseDetails = container;
        [self.page.refreshControl endRefreshing];
    } onError:^(APIError *err) {
        ALERT_VIEW_WITH_TITLE(err.errorCode, err.errorMsg);
        [self.page.refreshControl endRefreshing];
    }];
}
@end
