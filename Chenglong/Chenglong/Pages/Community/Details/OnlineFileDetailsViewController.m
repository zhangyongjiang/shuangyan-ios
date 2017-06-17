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

@interface OnlineFileDetailsViewController ()

@property(strong, nonatomic) OnlineCourseDetailsView* courseDetailsView;

@end

@implementation OnlineFileDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.courseDetails.course.title;

    self.courseDetailsView = [[OnlineCourseDetailsView alloc] initWithFrame:self.view.bounds];
    self.courseDetailsView.courseDetails = self.courseDetails;
    [self.view addSubview:self.courseDetailsView];
}

@end
