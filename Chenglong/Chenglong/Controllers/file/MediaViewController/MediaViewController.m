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
    self.view.clipsToBounds = YES;

    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.view.autoresizesSubviews = YES;
    
    self.mediaViewPage = [[MediaViewPage alloc] initWithFrame:self.view.bounds];
    self.mediaViewPage.courseDetails = self.courseDetails;
    [self.view addSubview:self.mediaViewPage];
    
    [self.mediaViewPage.btnClose addTarget:self action:@selector(cancelPressed:) forControlEvents:UIControlEventTouchUpInside];
    
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
@end
