//
//  CopyViewController.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 12/10/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "CopyViewController.h"

@interface CopyViewController ()

@end

@implementation CopyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)courseSelected {
    CourseDetails* selected = self.page.selectedCourseDetails;
    if(selected) {
        NSLog(@"course %@ %@ selected in CopyViewController", selected.course.id, selected.course.title);
        WeakSelf(weakSelf)
        [CourseApi CourseAPI_Copy:self.srcCourse.course.id dstId:selected.course.id onSuccess:^(Course *resp) {
            ALERT_VIEW_WITH_TITLE(NULL, @"拷贝成功");
            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
        } onError:^(APIError *err) {
            ALERT_VIEW_WITH_TITLE(NULL, @"拷贝出错");
            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}

@end
