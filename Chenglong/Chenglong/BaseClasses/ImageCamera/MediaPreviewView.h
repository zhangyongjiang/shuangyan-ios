//
//  MediaPreviewView.h
//  Kaishi
//
//  Created by Hyun Cho on 7/27/15.
//  Copyright (c) 2015 BCGDV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MediaPreviewView : UIView

@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) UIView* videoPlayerView;
@property (nonatomic, strong) UIButton* deleteButton;

//- (void)setVideoUrl:(NSURL*)url;
- (void)setMoviePlayerView:(UIView*)view;

@end
