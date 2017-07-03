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

    self.imgView = [UIImageView new];
    [self.imgView setContentMode:UIViewContentModeScaleToFill];
    [self addSubview:self.imgView];
    [self.imgView autoPinEdgesToSuperviewMargins];
    
    return self;
}

-(void)play {
    if(![self.localMediaContent isDownloaded]) {
        NSLog(@"no downloaded yet");
        return;
    }
    UIImage* img = [UIImage imageWithContentsOfFile:self.localMediaContent.filePath];
    self.imgView.image = img;
}

-(void)setLocalMediaContent:(LocalMediaContent *)localMediaContent {
    [super setLocalMediaContent:localMediaContent];
    if([localMediaContent isDownloaded])
        self.btnDownload.hidden = YES;
}

@end
