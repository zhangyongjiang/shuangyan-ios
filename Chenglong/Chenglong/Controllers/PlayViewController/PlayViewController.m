//
//  PlayViewController.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 10/17/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "PlayViewController.h"
#import "GalleryView.h"
#import "PlayerControlView.h"

@interface PlayViewController ()
@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"播放";

    self.page = [[PlayListPage alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.page];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playCourseNotiHandler:) name:NotificationPlayCourse object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playCourseListNotiHandler:) name:NotificationPlayCourseList object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playingNotiHandler:) name:NotificationPlayStart object:nil];
}

-(void)playingNotiHandler:(NSNotification*)noti
{
    PlayTask* pt = noti.object;
    NSString* title = NULL;
    if(pt.localMediaContent.parent.title.length>10)
        title = [pt.localMediaContent.parent.title substringToIndex:10];
    else
        title = pt.localMediaContent.parent.title;
    if(![self.title isEqualToString:title]){
        self.title = title;
    }
}

-(void)playCourseNotiHandler:(NSNotification*)noti
{
    CourseDetails* pt = noti.object;
    [self.page addCourseDetails:pt];
}

-(void)playCourseListNotiHandler:(NSNotification*)noti
{
    NSMutableArray* list = noti.object;
    [self.page addCourseDetailsList:list];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.page.frame = self.view.bounds;
}

@end
