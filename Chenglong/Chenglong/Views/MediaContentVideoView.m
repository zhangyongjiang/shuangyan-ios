//
//  MediaContentVideoView.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/11/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "MediaContentVideoView.h"
#import <AVFoundation/AVFoundation.h>

@interface MediaContentVideoView()
{
    AVPlayer* player;
}
@end

@implementation MediaContentVideoView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    return self;
}

-(void)setLocalMediaContent:(LocalMediaContent *)localMediaContent {
    [super setLocalMediaContent:localMediaContent];
    [self play];
}

-(void)play {
    if(![self.localMediaContent isDownloaded]) {
        NSLog(@"no downloaded yet");
        return;
    }
    NSURL* url = [NSURL fileURLWithPath:self.localMediaContent.filePath];
    player = [[AVPlayer alloc] initWithURL:url];
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
    layer.frame = CGRectMake(0, self.btnPlay.bottom+Margin, [UIView screenWidth], [UIView screenWidth]);
    [self.layer addSublayer:layer];
    layer.backgroundColor = [UIColor clearColor].CGColor;
    [layer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [player play];
}

@end
