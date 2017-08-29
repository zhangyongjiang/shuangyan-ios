//
//  MediaViewController.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 7/4/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "MediaViewController.h"
#import "GalleryView.h"

@interface MediaViewController ()
@property(strong, nonatomic)GalleryView* galleryView;

@end

@implementation MediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;

    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.view.autoresizesSubviews = YES;
    
    self.galleryView = [[GalleryView alloc] initWithFrame:self.view.bounds];
    [self.galleryView showText:self.courseDetails.course.content andMediaContent:self.courseDetails.course.resources];
    [self.view addSubview:self.galleryView];
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 60, 40)];
    btn.backgroundColor = [UIColor colorFromRGBA:0xa0a0a080];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"关闭" forState:UIControlStateNormal];
    btn.layer.borderColor = [UIColor blackColor].CGColor;
    btn.layer.borderWidth = 0.5;
    btn.layer.cornerRadius = btn.height / 2.;
    [btn addTarget:self action:@selector(cancelPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    [self.galleryView stop];
    [self.galleryView removeFromSuperview];
    self.galleryView = nil;
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
@end
