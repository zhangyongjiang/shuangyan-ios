//
//  SDImageCache+Thumbnail.h
//  Kaishi
//
//  Created by Hyun Cho on 12/10/15.
//  Copyright © 2015 BCGDV. All rights reserved.
//

#import <SDWebImage/SDImageCache.h>

@interface SDImageCache (Thumbnail)

+ (NSString*)thumbnailName:(NSString*)urlString;
+ (NSURL*)thumbnailUrl:(NSString*)urlString;
+ (UIImage*)resizeImageAtPath:(NSString *)imagePath andStoreToThumbnailPath:(NSString*)destination thumbSize:(CGFloat)thumbSize;
+ (UIImage*)resizeImage:(UIImage*)image andStoreToThumbnailPath:(NSString*)destination thumbSize:(CGFloat)thumbSize;
- (UIImage*)imageFromDiskCacheForKey:(NSString *)key checkThumbnail:(BOOL)checkthumbnail;

@end

extern const CGFloat kDefaultMediaThumbSize;
extern const CGFloat kDefaultUserPhotoThumbSize;