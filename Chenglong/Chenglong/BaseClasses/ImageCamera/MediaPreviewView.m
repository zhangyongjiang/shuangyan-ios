//
//  MediaPreviewView.m
//  Kaishi
//
//  Created by Hyun Cho on 7/27/15.
//  Copyright (c) 2015 BCGDV. All rights reserved.
//

#import "MediaPreviewView.h"

@interface MediaPreviewView ()

@end

@implementation MediaPreviewView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    
    _videoPlayerView = [UIView newAutoLayoutView];
    [self addSubview:_videoPlayerView];
    
    _imageView = [UIImageView newAutoLayoutView];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_imageView];
    
    _deleteButton = [UIButton newAutoLayoutView];
    [_deleteButton setImage:[UIImage imageNamed:@"button_delete"] forState:UIControlStateNormal];
    _deleteButton.backgroundColor = UIColorFromRGB(0xf83f37); // reddish color
    [self addSubview:_deleteButton];
    
    return self;
}


- (void)updateConstraints {
    const CGFloat buttonSize = 24;
    
    [self.imageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    [self.videoPlayerView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.videoPlayerView autoPinEdgeToSuperviewEdge:ALEdgeRight];    
    [self.videoPlayerView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.videoPlayerView autoSetDimension:ALDimensionHeight toSize:200];
    
    [self.deleteButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20+8];
    [self.deleteButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:8];
    [self.deleteButton autoSetDimensionsToSize:CGSizeMake(buttonSize, buttonSize)];
    self.deleteButton.layer.cornerRadius = buttonSize * 0.5;
    
    [super updateConstraints];
}


- (void)setMoviePlayerView:(UIView*)view {
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoPlayerView addSubview:view];
    [view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}


@end
