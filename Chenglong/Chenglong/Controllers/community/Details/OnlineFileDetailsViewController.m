//
//  FileDetailsViewController.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "OnlineFileDetailsViewController.h"
#import "MediaContentAudioView.h"
#import "OnlineCourseDetailsView.h"
#import "CoursePickerViewController.h"

@interface OnlineFileDetailsViewController ()<CousePickerDelegate>

@property(strong, nonatomic) OnlineCourseDetailsView* courseDetailsView;
@property(strong, nonatomic) CourseDetailsWithParent* courseDetailsWithParent;
@property(strong, nonatomic) CoursePickerViewController* coursePickerViewController;

@end

@implementation OnlineFileDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshPage];
    [self addTopRightMenu];
}

-(void)addTopRightMenu {
    NSMutableArray* arr = [NSMutableArray arrayWithObjects:
                           [[MenuItem alloc] initWithText:@"拷贝" andImgName:@"file_item_newFile_icon"],
                           [[MenuItem alloc] initWithText:@"上传者" andImgName:@"file_search_age_icon"],
                           nil];
    self.menuItems = arr;
    [super addTopRightMenu:arr];
}

-(void)topRightMenuItemClicked:(NSString *)cmd {
    [super topRightMenuItemClicked:cmd];
    if ([cmd isEqualToString:@"拷贝"]) {
        self.coursePickerViewController = [[CoursePickerViewController alloc] init];
        [self.navigationController pushViewController:self.coursePickerViewController animated:YES];
        self.coursePickerViewController.delegate = self;
    }
    else if ([cmd isEqualToString:@"上传者"]){
    }
}

-(void)refreshPage {
    [CourseApi CourseAPI_GetCourseDetails:self.courseId onSuccess:^(CourseDetailsWithParent *resp) {
        self.courseDetailsWithParent = resp;
        self.courseDetailsView = [[OnlineCourseDetailsView alloc] initWithFrame:self.view.bounds];
        self.courseDetailsView.courseDetailsWithParent = resp;
        [self.view addSubview:self.courseDetailsView];
        self.title = resp.courseDetails.course.title;
    } onError:^(APIError *err) {
        
    }];
}

-(void)selectCourse:(NSString*)selected {
    if(selected == NULL)
        selected = @"~";
    [self.navigationController popToViewController:self animated:YES];
    [CourseApi CourseAPI_Copy:self.courseId dstId:selected onSuccess:^(Course *resp) {
        [self alertShowWithMsg:@"Done"];
    } onError:^(APIError *err) {
        [self alertShowWithMsg:@"Error"];
    }];
}

@end
