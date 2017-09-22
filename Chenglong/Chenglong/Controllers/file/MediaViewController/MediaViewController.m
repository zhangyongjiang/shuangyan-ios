//
//  MediaViewController.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 7/4/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "MediaViewController.h"
#import "GalleryView.h"
#import "GalleryCollectionView.h"

@interface MediaViewController ()
@property(strong, nonatomic)GalleryView* galleryView;

@end

@implementation MediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.courseDetails.course.title;
    self.view.clipsToBounds = YES;

    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.view.autoresizesSubviews = YES;
    
    self.galleryView = [[GalleryView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.galleryView];
    
    [super addTopRightMenu];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playingNotiHandler:) name:NotificationPlayStart object:nil];
}

-(void)playingNotiHandler:(NSNotification*)noti
{
    PlayTask* pt = noti.object;
    if(![self.title isEqualToString:pt.localMediaContent.parent.title])
        self.title = pt.localMediaContent.parent.title;
}

-(NSMutableArray*)getTopRightMenuItems
{
    NSMutableArray* menuItems = [NSMutableArray new];
    if(![Global isLoginUser:self.courseDetails.course.userId]) {
        [menuItems addObject:[[MenuItem alloc] initWithText:@"拷贝" andImgName:@"file_item_download_icon"]];
    }
    if([Global isLoginUser:self.courseDetails.course.userId] || [Global isSuperUser]){
        [menuItems addObject:[[MenuItem alloc] initWithText:@"删除" andImgName:@"file_item_remove_icon"]];
        [menuItems addObject:[[MenuItem alloc] initWithText:@"改名" andImgName:@"file_item_edit_icon"]];
        [menuItems addObject:[[MenuItem alloc] initWithText:@"移动" andImgName:@"file_item_exchange_icon"]];
        [menuItems addObject:[[MenuItem alloc] initWithText:@"拷贝" andImgName:@"file_item_download_icon"]];
    }
    return menuItems;
}

-(void)topRightMenuItemClicked:(NSString *)cmd
{
    if([cmd isEqualToString:@"拷贝"]) {
        
    }
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.galleryView.frame = self.view.bounds;
}

-(void)play
{
    [self.galleryView play];
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)setCourseDetails:(CourseDetails *)courseDetails
{
    _courseDetails = courseDetails;
    self.galleryView.courseDetails = self.courseDetails;
}
@end
