//
//  TreePickerViewController.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 11/5/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "TreePickerViewController.h"

@interface TreePickerViewController ()

@end

@implementation TreePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect rect = self.view.bounds;
    rect.size.height = rect.size.height - 108;
    self.page = [[CourseTreePage alloc] initWithFrame:rect];
        self.title = @"我的文件";
    
    self.view.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.page];
    
    [self showPage];
    [self addNavRightButton:@"完成" target:self action:@selector(courseSelected)];
}

-(void)courseSelected {
    NSLog(@"course selected");
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)showPage {
    [CourseApi CourseAPI_ListUserCourseTree:NULL onSuccess:^(CourseDetails *resp) {
        [resp sortChild];
        resp.course = [Course new];
        resp.course.isDir = [NSNumber numberWithInteger:1];
        
        CourseDetails* container = [CourseDetails new];
        container.course = [Course new];
        container.course.isDir = [NSNumber numberWithInt:1];
        container.items = [NSMutableArray arrayWithObject:resp];
        self.page.courseDetails = container;
        [self.page.refreshControl endRefreshing];
    } onError:^(APIError *err) {
        ALERT_VIEW_WITH_TITLE(err.errorCode, err.errorMsg);
        [self.page.refreshControl endRefreshing];
    }];
}

@end
