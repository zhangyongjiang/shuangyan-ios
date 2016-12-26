//
//  UIImageView+Thumbnail.h
//  Kaishi
//
//  Created by Hyun Cho on 11/13/15.
//  Copyright © 2015 BCGDV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface UIImageView (Thumbnail)

- (void)loadWithThumbnail:(NSString*)urlString placeholder:(UIImage*)placeHolder thumbSize:(CGFloat)thumbSize;
- (void)loadWithThumbnail:(NSString*)urlString placeholder:(UIImage*)placeHolder thumbSize:(CGFloat)thumbSize completed:(SDWebImageCompletionBlock)completedBlock;

@end
