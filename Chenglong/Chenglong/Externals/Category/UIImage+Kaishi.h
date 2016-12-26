//
//  UIImage+Kaishi.h
//  Kaishi
//
//  Created by Hyun Cho on 6/13/15.
//  Copyright (c) 2015 BCGDV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Kaishi)

- (UIImage*)gaussianBlurImage;
- (UIImage*)resizedImage:(CGSize)size;
- (UIImage*)fixOrientation;
- (UIImage*)resizeImageToMaxHeight;
- (UIImage*)resizeImageToHeight:(CGFloat)height;
- (UIImage*)resizeImageToWidth:(CGFloat)width;
+ (UIImage*)imageWithColor:(UIColor*)color; // returns a small 1Wx1H image with the color filled in
- (NSData*)thumnbailDataForSharing;

@end
