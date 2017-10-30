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

    CGRect rect = self.view.bounds;
    rect.size.height -= 64;
    [self addTopRightMenu];

    self.page = [[PlayListPage alloc] initWithFrame:rect];
    [self.view addSubview:self.page];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playCourseNotiHandler:) name:NotificationPlayCourse object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playCourseAppendNotiHandler:) name:NotificationPlayCourseAppend object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playCourseListNotiHandler:) name:NotificationPlayCourseList object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playingNotiHandler:) name:NotificationPlayStart object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleFullscreen:) name:NotificationFullscreen object:nil];
}

-(void)toggleFullscreen:(NSNotification*)noti
{
    if([AppDelegate isLandscape])
        return;
    if(!self.navigationController.navigationBar.hidden) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    } else {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

-(NSMutableArray*)getTopRightMenuItems {
    NSMutableArray* menuItems = [[NSMutableArray alloc] init];
    [menuItems addObject:[[MenuItem alloc] initWithText:@"清除" andImgName:@"ic_clear"]] ;
    return menuItems;
}

-(void)topRightMenuItemClicked:(NSString *)cmd {
    if([cmd isEqualToString:@"清除"]) {
        self.page.playList = [NSMutableArray new];
    }
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
    [self.page addCourseDetailsToBeginning:pt];
}

-(void)playCourseAppendNotiHandler:(NSNotification*)noti
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

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
