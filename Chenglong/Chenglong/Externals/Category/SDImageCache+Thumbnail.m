//
//  SDImageCache+Thumbnail.m
//  Kaishi
//
//  Created by Hyun Cho on 12/10/15.
//  Copyright © 2015 BCGDV. All rights reserved.
//

#import "SDImageCache+Thumbnail.h"
#import "UIImage+Kaishi.h"
#import <ImageIO/ImageIO.h>

const CGFloat kDefaultMediaThumbSize = 100.0;
const CGFloat kDefaultUserPhotoThumbSize = 40.0;

@implementation SDImageCache (Thumbnail)

+ (NSString*)thumbnailName:(NSString*)urlString {
    NSURL* url = [NSURL URLWithString:urlString];
    NSString* pathExtension = [url pathExtension];
    NSString* thumbnailString;
    if ( pathExtension.length > 0 ) {
        NSString* ext = [NSString stringWithFormat:@".%@", pathExtension];
        thumbnailString = [urlString stringByReplacingOccurrencesOfString:ext withString:[NSString stringWithFormat:@"_T.%@", pathExtension]];
    } else {
        thumbnailString = [urlString stringByAppendingString:@"_T"];
    }
    return thumbnailString;
}


+ (NSURL*)thumbnailUrl:(NSString*)urlString {
    return [NSURL URLWithString:[self thumbnailName:urlString]];;
}


+ (UIImage*)resizeImageAtPath:(NSString *)imagePath andStoreToThumbnailPath:(NSString*)destination thumbSize:(CGFloat)thumbSize {
    UIImage* image = [UIImage imageWithContentsOfFile:imagePath];
    if ( image != nil ) {
        return [self resizeImage:image andStoreToThumbnailPath:destination thumbSize:thumbSize];
    }
    
    return nil;
}


+ (UIImage*)resizeImage:(UIImage*)image andStoreToThumbnailPath:(NSString*)destination thumbSize:(CGFloat)thumbSize {
    
    UIImage* thumbnailImage = [image resizeImageToHeight:thumbSize];
    if ( thumbnailImage ) {
        [[SDImageCache sharedImageCache] storeImage:thumbnailImage forKey:destination];
    }
    
    return thumbnailImage;
}


- (UIImage*)imageFromDiskCacheForKey:(NSString *)key checkThumbnail:(BOOL)checkthumbnail {
    NSString *thumbnailName = [NSString stringWithFormat:@"%@_T", key];

    UIImage* image;
    
    if (checkthumbnail) {
        image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:thumbnailName];
        if (image) {
            return image;
        }
    }
    
    NSString *source = [[SDImageCache sharedImageCache] defaultCachePathForKey:key];
    BOOL existKey = [[SDImageCache sharedImageCache] diskImageExistsWithKey:key];
    BOOL existThunbnail = [[SDImageCache sharedImageCache] diskImageExistsWithKey:thumbnailName];
    
    if (checkthumbnail && existKey) {
        if (!existThunbnail) {
            [SDImageCache resizeImageAtPath:source andStoreToThumbnailPath:thumbnailName thumbSize:0.0];
        }
        image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:thumbnailName];
        return image;
    }
    image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
    if ( image != nil ) {
        return image;
    }
    
    return nil;
}


@end
