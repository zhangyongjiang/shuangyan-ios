//
//  DVFullScreenMediaScrollView.m
//  Kaishi
//
//  Created by Hyun Cho on 1/25/16.
//  Copyright © 2016 BCGDV. All rights reserved.
//

#import "DVFullScreenMediaScrollView.h"

@interface DVFullScreenMediaScrollView () <UIScrollViewDelegate>

@end

@implementation DVFullScreenMediaScrollView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.delegate = self;
    self.backgroundColor = [UIColor clearColor];
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    
    self.minimumZoomScale = 1.0;
    self.maximumZoomScale = 2.5;

    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_imageView];
    
    return self;
}


- (void)zoomInZoomOut:(CGPoint)point {
    // Check if current Zoom Scale is greater than half of max scale then reduce zoom and vice versa
    CGFloat newZoomScale = (self.zoomScale > self.minimumZoomScale) ? self.minimumZoomScale : self.maximumZoomScale;
    
    CGSize scrollViewSize = self.bounds.size;
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = point.x - (w / 2.0f);
    CGFloat y = point.y - (h / 2.0f);
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    [self zoomToRect:rectToZoomTo animated:YES];
}


#pragma Helper functions

- (void)centerFrameFromImage:(UIImage*)image {
    if (!image) {
        return;
    }
    
    CGRect windowBounds = self.bounds;
    CGSize newImageSize = [self imageResizeBaseOnWidth:windowBounds.size.width oldWidth:image.size.width oldHeight:image.size.height];
    
    CGFloat orginY = 0;
    if (newImageSize.height > windowBounds.size.height) {
        orginY = 0;
        self.contentSize = CGSizeMake(windowBounds.size.width, newImageSize.height);
    }else{
        orginY = windowBounds.size.height/2 - newImageSize.height/2;
        self.contentSize = CGSizeMake(windowBounds.size.width, windowBounds.size.height);
    }
    CGRect rect = CGRectMake(0, orginY, newImageSize.width, newImageSize.height);
    self.imageView.frame = rect;
}


- (CGSize)imageResizeBaseOnWidth:(CGFloat) newWidth oldWidth:(CGFloat) oldWidth oldHeight:(CGFloat)oldHeight {
    CGFloat scaleFactor = newWidth / oldWidth;
    CGFloat newHeight = oldHeight * scaleFactor;
    return CGSizeMake(newWidth, newHeight);
    
}

# pragma mark - UIScrollView Delegate
- (void)centerScrollViewContents {
    CGSize boundsSize = self.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    self.imageView.frame = contentsFrame;
}


- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if ( self.fsmDelegate != nil ) {
        [self.fsmDelegate scrollViewChangedZoom:self];
    }
   [self centerScrollViewContents];
}



@end
