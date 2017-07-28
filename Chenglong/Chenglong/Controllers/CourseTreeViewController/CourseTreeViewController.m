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
    [self.view addSubview:self.page];
    [self refreshPage];
}

-(void)refreshPage {
    [CourseApi CourseAPI_ListUserCourseTree:self.userId onSuccess:^(CourseDetails *resp) {
        
    } onError:^(APIError *err) {
        
    }];
}
@end
