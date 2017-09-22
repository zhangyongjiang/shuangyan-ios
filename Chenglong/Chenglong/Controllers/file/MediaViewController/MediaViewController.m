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
#import "MediaViewPage.h"

@interface MediaViewController ()
@property(strong, nonatomic)MediaViewPage* mediaViewPage;

@end

@implementation MediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.courseDetails.course.title;
    self.view.clipsToBounds = YES;

    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.view.autoresizesSubviews = YES;
    
    self.mediaViewPage = [[MediaViewPage alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.mediaViewPage];
    
    [super addTopRightMenu];
    
    [self.mediaViewPage.btnClose addTarget:self action:@selector(cancelPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.mediaViewPage.btnPrev addTarget:self action:@selector(previous:) forControlEvents:UIControlEventTouchUpInside];
    [self.mediaViewPage.btnNext addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    
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

-(void)previous:(id)sender
{
    BOOL success = [self.mediaViewPage.galleryView previous];
    if(success)
        [self.mediaViewPage.galleryView play];
}

-(void)next:(id)sender
{
    BOOL success = [self.mediaViewPage.galleryView next];
    if(success)
        [self.mediaViewPage.galleryView play];
}

-(void)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    [self.mediaViewPage.galleryView stop];
    [self.mediaViewPage.galleryView removeFromSuperview];
    self.mediaViewPage.galleryView = nil;
    self.mediaViewPage = nil;
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.mediaViewPage.frame = self.view.bounds;
}

-(void)play
{
    [self.mediaViewPage.galleryView play];
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)setCourseDetails:(CourseDetails *)courseDetails
{
    _courseDetails = courseDetails;
    self.mediaViewPage.courseDetails = self.courseDetails;
}
@end
