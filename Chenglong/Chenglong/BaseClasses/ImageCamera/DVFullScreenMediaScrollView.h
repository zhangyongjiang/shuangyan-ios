//
//  DVFullScreenMediaScrollView.h
//  Kaishi
//
//  Created by Hyun Cho on 1/25/16.
//  Copyright © 2016 BCGDV. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DVFullScreenMediaScrollView;

@protocol DVFullScreenMediaScrollViewDelegate <NSObject>

- (void)scrollViewChangedZoom:(DVFullScreenMediaScrollView*)scrollView;

@end


@interface DVFullScreenMediaScrollView : UIScrollView

- (void)zoomInZoomOut:(CGPoint)point;
- (void)centerFrameFromImage:(UIImage*)image;

@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, weak) id<DVFullScreenMediaScrollViewDelegate> fsmDelegate;

@end
