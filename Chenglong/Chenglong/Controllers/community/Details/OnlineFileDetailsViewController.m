//
//  FileDetailsViewController.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "OnlineFileDetailsViewController.h"
#import "OnlineCourseDetailsView.h"
#import "CoursePickerViewController.h"
#import "CourseTreeViewController.h"

@interface OnlineFileDetailsViewController ()<CousePickerDelegate>

@property(strong, nonatomic) OnlineCourseDetailsView* courseDetailsView;
@property(strong, nonatomic) CourseDetailsWithParent* courseDetailsWithParent;
@property(strong, nonatomic) CoursePickerViewController* coursePickerViewController;

@end

@implementation OnlineFileDetailsViewController

-(NSMutableArray*)getTopRightMenuItems {
    NSMutableArray* arr = [NSMutableArray arrayWithObjects:
                           [[MenuItem alloc] initWithText:@"拷贝" andImgName:@"file_item_newFile_icon"],
                           [[MenuItem alloc] initWithText:@"上传者" andImgName:@"file_search_age_icon"],
                           nil];
    return arr;
}

-(void)topRightMenuItemClicked:(NSString *)cmd {
    [super topRightMenuItemClicked:cmd];
    if ([cmd isEqualToString:@"拷贝"]) {
        self.coursePickerViewController = [[CoursePickerViewController alloc] init];
        [self.navigationController pushViewController:self.coursePickerViewController animated:YES];
        self.coursePickerViewController.delegate = self;
    }
    else if ([cmd isEqualToString:@"上传者"]){
        CourseTreeViewController* controller = [[CourseTreeViewController alloc] initWithUserId:self.courseDetails.course.userId andCourseId:nil];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
