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
    AVPlayerLayer *layer;
    BOOL playing;
}
@end

@implementation MediaContentVideoView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self addTarget:self action:@selector(clicked)];
    return self;
}

-(void)clicked {
    NSLog(@"clicked");
    if(playing)
        [player pause];
    else
        [player play];
    playing = !playing;
}

-(void)play {
    if(![self.localMediaContent isDownloaded]) {
        NSLog(@"no downloaded yet");
        return;
    }
    self.btnDownload.hidden = YES;
    playing = YES;
    
    NSURL* url = [NSURL fileURLWithPath:self.localMediaContent.filePath];
    player = [[AVPlayer alloc] initWithURL:url];
    layer = [AVPlayerLayer playerLayerWithPlayer:player];
    layer.frame = self.bounds;
    [self.layer addSublayer:layer];
    layer.backgroundColor = [UIColor clearColor].CGColor;
    [layer setVideoGravity:AVLayerVideoGravityResizeAspect];
    [player play];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    layer.frame = self.bounds;
}

@end
