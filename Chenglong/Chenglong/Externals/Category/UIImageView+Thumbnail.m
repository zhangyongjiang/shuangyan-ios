//
//  UIImageView+Thumbnail.m
//  Kaishi
//
//  Created by Hyun Cho on 11/13/15.
//  Copyright © 2015 BCGDV. All rights reserved.
//

#import "UIImageView+Thumbnail.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache+Thumbnail.h"
#import <ImageIO/ImageIO.h>

@implementation UIImageView (Thumbnail)

- (void)loadWithThumbnail:(NSString*)urlString placeholder:(UIImage*)placeHolder thumbSize:(CGFloat)thumbSize {
    [self loadWithThumbnail:urlString placeholder:placeHolder thumbSize:thumbSize completed:nil];
}


- (void)loadWithThumbnail:(NSString*)urlString placeholder:(UIImage*)placeHolder thumbSize:(CGFloat)thumbSize completed:(SDWebImageCompletionBlock)completedBlock {
    
    NSAssert([NSThread isMainThread], @"Must be called from the main thread");
    
    NSString *thumbnailName = [NSString stringWithFormat:@"%@_T", urlString];
    
    NSString *source = [[SDImageCache sharedImageCache] defaultCachePathForKey:urlString];

    BOOL existKey = [[SDImageCache sharedImageCache] diskImageExistsWithKey:urlString];
    BOOL existThumbnail = [[SDImageCache sharedImageCache] diskImageExistsWithKey:thumbnailName];
    
    __weak typeof(self) weakSelf = self;
    self.contentMode = UIViewContentModeScaleAspectFill;

    if (existKey) {
        UIImage* thumbnailImage;
        if (!existThumbnail) {
            // source exists, but the thumbnail doesn't
            thumbnailImage = [SDImageCache resizeImageAtPath:source andStoreToThumbnailPath:thumbnailName thumbSize:thumbSize];
        }
        if ( completedBlock != nil ) {
            if ( thumbnailImage == nil ) {
                thumbnailImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:thumbnailName];
            }
            self.image = thumbnailImage;
            [self setNeedsLayout];
            [self layoutIfNeeded];
            
            completedBlock(self.image, nil, SDImageCacheTypeDisk, [NSURL URLWithString:thumbnailName]);
        }
        return;
    }
    
    [self sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:placeHolder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if ( error != nil ) {
            // errored out
            
        } else {
            UIImage* thumbnailImage;
            if (image) {
               thumbnailImage = [SDImageCache resizeImage:image andStoreToThumbnailPath:thumbnailName thumbSize:thumbSize];
                weakSelf.image = thumbnailImage;
            } else {
                weakSelf.image=nil;
            }
            if (completedBlock) {
                completedBlock(thumbnailImage, error, cacheType, imageURL);
            }
        }
    }];

}

@end
