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
@property(strong, nonatomic) GalleryView* galleryView;
@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"播放";
    
    self.galleryView = [[GalleryView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.galleryView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playCourseNotiHandler:) name:NotificationPlayCourse object:nil];
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
