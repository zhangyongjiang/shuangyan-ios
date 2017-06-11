//
//  MediaContentImageView.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/10/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "MediaContentImageView.h"

@implementation MediaContentImageView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    self.imgView = [[UIImageView alloc] initWithFrame:frame];
    [self.imgView setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:self.imgView];
    
    return self;
}

-(void)setLocalMediaContent:(LocalMediaContent *)mediaContent {
    [super setLocalMediaContent:mediaContent];
    if([self isDownloaded]) {
        [self showImage];
    }
}

-(void)showImage {
    UIImage* img = [UIImage imageWithContentsOfFile:self.localMediaContent.filePath];
    self.imgView.image = img;
}

@end
