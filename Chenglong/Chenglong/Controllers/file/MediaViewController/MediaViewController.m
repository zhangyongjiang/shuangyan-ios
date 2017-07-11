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
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    self.galleryView = [[GalleryView alloc] initWithFrame:self.view.bounds];
    self.galleryView.mediaContents = self.mediaContents;
    [self.view addSubview:self.galleryView];
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 100, 40)];
    btn.backgroundColor = [UIColor colorFromRGB:0xa0a0a0];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"Cancel" forState:UIControlStateNormal];
    btn.layer.borderColor = [UIColor blackColor].CGColor;
    btn.layer.borderWidth = 0.5;
    btn.layer.cornerRadius = btn.height / 2.;
    [btn addTarget:self action:@selector(cancelPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    self.view.width = size.width;
    self.view.height = size.height;
    self.galleryView.width = size.width;
    self.galleryView.height = size.height;
}

-(void)play
{
    [self.galleryView play];
}
@end
