//
//  MediaContentVideoView.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/11/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "MediaContentVideoView.h"
#import <AVFoundation/AVFoundation.h>
#import "MediaPlayer.h"

@interface MediaContentVideoView()
{
    MediaPlayer* player;
    AVPlayerLayer *layer;
}
@end

@implementation MediaContentVideoView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self addTarget:self action:@selector(clicked)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(background:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(foreground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    return self;
}

-(void)background:(NSNotification*)noti {
    [layer removeFromSuperlayer];
    layer = nil;
    [player play];
}

-(void)foreground:(NSNotification*)noti {
    if(layer) return;
    layer = [AVPlayerLayer playerLayerWithPlayer:player.avplayer];
    layer.frame = self.bounds;
    [self.layer addSublayer:layer];
    layer.backgroundColor = [UIColor clearColor].CGColor;
    [layer setVideoGravity:AVLayerVideoGravityResizeAspect];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [player pause];
    player = nil;
}

-(void)clicked {
    NSLog(@"clicked");
    if([player isPlaying])
        [player pause];
    else
        [player play];
}

-(void)play {
//    if(![self.mediaContent isDownloaded]) {
//        NSLog(@"no downloaded yet");
//        return;
//    }
    if(!player) {
        player = [MediaPlayer shared];
        PlayTask* task = [[PlayTask alloc] init];
        task.mediaContent = self.mediaContent;
        [player addPlayTask:task];
        [player play];
        layer = [AVPlayerLayer playerLayerWithPlayer:player.avplayer];
        layer.frame = self.bounds;
        [self.layer addSublayer:layer];
        layer.backgroundColor = [UIColor clearColor].CGColor;
        [layer setVideoGravity:AVLayerVideoGravityResizeAspect];
        [self.btnDownload setTitle:@"暂停" forState: UIControlStateNormal];
        return;
    }
    if([player isPlaying]) {
        [self.btnDownload setTitle:@"播放" forState: UIControlStateNormal];
        [player pause];
    }
    else {
        [self.btnDownload setTitle:@"暂停" forState: UIControlStateNormal];
        [player play];
    }
}

-(void)destroy
{
    [player stop];
    [player removeTask:self.mediaContent];
    player = nil;
}

-(BOOL)isPlaying {
    return [player isPlaying];
}

-(void)test
{
    AVAsset *asset = [AVAsset assetWithURL:[self.mediaContent playUrl]];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    CMTime time = CMTimeMake(1, 1);
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);  // CGImageRef won't be released by ARC
}
@end
