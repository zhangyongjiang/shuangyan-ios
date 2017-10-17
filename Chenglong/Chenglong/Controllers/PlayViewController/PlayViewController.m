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
    self.title = @"播放";
    
    self.galleryView = [[GalleryView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.galleryView];
    [self.galleryView autoPinEdgesToSuperviewMargins];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playCourseNotiHandler:) name:NotificationPlayCourse object:nil];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
