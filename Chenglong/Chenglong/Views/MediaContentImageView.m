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
    
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIView screenWidth], [UIView screenWidth])];
    [self.imgView setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:self.imgView];
    
    return self;
}

-(void)play {
    if(![self.localMediaContent isDownloaded]) {
        NSLog(@"no downloaded yet");
        return;
    }
    self.imgView.y = 0;
    self.imgView.height = [UIView screenHeight] - self.imgView.y;
    UIImage* img = [UIImage imageWithContentsOfFile:self.localMediaContent.filePath];
    self.imgView.image = img;
}

-(void)setLocalMediaContent:(LocalMediaContent *)localMediaContent {
    [super setLocalMediaContent:localMediaContent];
    if([localMediaContent isDownloaded])
        self.btnDownload.hidden = YES;
}

@end
