//
//  CoursePickerViewController.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/30/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "CoursePickerViewController.h"
#import "OnlineDirListPage.h"

@interface CoursePickerViewController ()

@property(strong, nonatomic) OnlineDirListPage* page;

@end

@implementation CoursePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavRightButton:@"Done" target:self action:@selector(courseSelected)];
    [self createPage];
    if(self.courseId == NULL)
        self.title = @"根目录";
}

-(void)createPage {
    self.page = [[OnlineDirListPage alloc] initWithFrame:self.view.bounds];
    self.page.delegate = self.delegate;
    [self.view addSubview:self.page];    
    [self refreshPage];
    [self.page autoPinEdgesToSuperviewMargins];
}

-(void)refreshPage {
    [CourseApi CourseAPI_ListUserCourses:NULL currentDirId:self.courseId page:0 onSuccess:^(CourseDetailsList *resp) {
        if(resp.courseDetails) {
            self.navigationItem.title = resp.courseDetails.course.title;
        }
        NSMutableArray* dironly = [NSMutableArray arrayWithCapacity:0];
        for (CourseDetails* cd in resp.items) {
            if(cd.course.isDir.intValue == 1) {
                [dironly addObject:cd];
            }
        }
        resp.items = dironly;
        if(dironly.count == 0)
            [self.page setEmptyPageText:@"空文件夹"];
        [self.page setCourseDetailsList:resp];
    } onError:^(APIError *err) {
        
    }];
}

-(void)courseSelected {
    [self.delegate selectCourse:self.courseId];
}
@end
