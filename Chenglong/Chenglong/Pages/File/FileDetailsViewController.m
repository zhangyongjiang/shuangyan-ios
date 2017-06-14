//
//  FileDetailsViewController.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "FileDetailsViewController.h"
#import "MediaContentAudioView.h"
#import "CourseDetailsView.h"

@interface FileDetailsViewController ()

@property(strong, nonatomic) CourseDetailsView* courseDetailsView;

@end

@implementation FileDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.localCourseDetails.courseDetails.course.title;
    [self addTopRightMenu];

    self.courseDetailsView = [[CourseDetailsView alloc] initWithFrame:self.view.bounds];
    self.courseDetailsView.localCourseDetails = self.localCourseDetails;
    [self.view addSubview:self.courseDetailsView];
}

-(void)addTopRightMenu {
    NSMutableArray* arr = [NSMutableArray arrayWithObjects:
                           [[MenuItem alloc] initWithText:@"改名" andImgName:@"file_item_edit_icon"],
                           [[MenuItem alloc] initWithText:@"播放" andImgName:@"file_item_play_icon"],
                           [[MenuItem alloc] initWithText:@"删除" andImgName:@"file_item_remove_icon"],
                           nil];
    [super addTopRightMenu:arr];
}

@end
