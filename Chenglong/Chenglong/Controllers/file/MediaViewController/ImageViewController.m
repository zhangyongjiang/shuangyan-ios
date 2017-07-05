//
//  ViewController.m
//  ZoomableScrollView
//
//  Created by SPM on 13/01/2014.
//  Copyright (c) 2014 . All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()
@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    UIImage* img = [UIImage imageWithContentsOfFile:self.imagePath];
    if(img.size.width/img.size.height > self.view.width/self.view.height) {
        CGFloat w = self.view.width;
        CGFloat h = w * img.size.height / img.size.width;
        CGFloat y = (self.view.height - h)/2.;
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, w, h)];
    }
    else {
        CGFloat h = self.view.height;
        CGFloat w = h * img.size.width / img.size.height;
        CGFloat x = (self.view.width - w)/2.;
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, w, h)];
    }
    self.imageView.image = img;
    [self.view addSubview:self.imageView];
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 100, 40)];
    btn.backgroundColor = [UIColor colorFromRGB:0xa0a0a0];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"Cancel" forState:UIControlStateNormal];
    btn.layer.borderColor = [UIColor blackColor].CGColor;
    btn.layer.borderWidth = 0.5;
    btn.layer.cornerRadius = btn.height / 2.;
    [btn addTarget:self action:@selector(cancelPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
    
    [self.view addTarget:self action:@selector(cancelPressed:)];
    
}

-(void)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.scrollView.zoomScale == self.scrollView.minimumZoomScale) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Private methods

- (IBAction)handleSingleTap:(UIButton *)tapGestureRecognizer {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
