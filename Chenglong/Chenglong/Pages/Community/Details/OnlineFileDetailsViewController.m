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
@property(strong, nonatomic) CourseDetailsWithParent* courseDetailsWithParent;

@end

@implementation OnlineFileDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)refreshPage {
    [CourseApi CourseAPI_GetCourseDetails:self.courseId onSuccess:^(CourseDetailsWithParent *resp) {
        self.courseDetailsWithParent = resp;
        self.courseDetailsView = [[OnlineCourseDetailsView alloc] initWithFrame:self.view.bounds];
        self.courseDetailsView.courseDetails = resp.courseDetails;
        [self.view addSubview:self.courseDetailsView];
        self.title = resp.courseDetails.course.title;
    } onError:^(APIError *err) {
        
    }];
}
@end
