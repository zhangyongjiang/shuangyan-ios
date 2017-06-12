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

    self.courseDetailsView = [[CourseDetailsView alloc] initWithFrame:self.view.bounds];
    self.courseDetailsView.localCourseDetails = self.localCourseDetails;
    [self.view addSubview:self.courseDetailsView];
}

@end
