//
//  PlayViewController.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 10/17/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "PlayViewController.h"
#import "GalleryView.h"

@interface PlayViewController ()
@property(strong, nonatomic) GalleryView* galleryView;
@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.title = @"播放";
    
    self.galleryView = [[GalleryView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.galleryView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playCourseNotiHandler:) name:NotificationPlayCourse object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playingNotiHandler:) name:NotificationPlayStart object:nil];
}

-(void)playingNotiHandler:(NSNotification*)noti
{
    PlayTask* pt = noti.object;
    if(![self.title isEqualToString:pt.localMediaContent.parent.title])
        self.title = pt.localMediaContent.parent.title;
}

-(void)playCourseNotiHandler:(NSNotification*)noti
{
    CourseDetails* pt = noti.object;
    self.galleryView.courseDetails = pt;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.galleryView.frame = self.view.bounds;
}

@end