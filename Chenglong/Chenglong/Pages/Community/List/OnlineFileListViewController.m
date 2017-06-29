//
//  OnlineFileListViewController.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "OnlineFileListViewController.h"
#import "ObjectMapper.h"
#import "CreateFileViewController.h"

@interface OnlineFileListViewController ()

@property(strong, nonatomic) OnlineFileListPage* page;

@end

@implementation OnlineFileListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createPage];
}

-(void)createPage {
    self.page = [[OnlineFileListPage alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.page];
    
    [self refreshPage];
}

-(void)refreshPage {
    [CourseApi CourseAPI_GetCourseDetails:self.courseId onSuccess:^(CourseDetailsWithParent *resp) {
        [self.page setCourseDetailsWithParent:resp];
    } onError:^(APIError *err) {
    }];
}

@end
