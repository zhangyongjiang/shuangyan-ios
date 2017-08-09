//
//  MediaPlayer.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 7/11/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "MediaPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface MediaPlayer()

@property (strong, nonatomic) AVPlayer* avplayer;
@property (strong, nonatomic) AVAudioPlayer* avAudioPlayer;
@property (strong, nonatomic) NSMutableArray* tasks;
@property (assign, nonatomic) int current;
@property (assign, nonatomic) BOOL useAvplayerForAudio;

@end

MediaPlayer* gMediaPlayer;

@implementation MediaPlayer

+(MediaPlayer*)shared
{
    if(!gMediaPlayer)
        gMediaPlayer = [MediaPlayer new];
    return gMediaPlayer;
}

-(id)init
{
    self = [super init];
    gMediaPlayer = self;
    self.tasks = [NSMutableArray new];
    self.useAvplayerForAudio = YES;
    return self;
}

-(void)addPlayTask:(PlayTask *)task {
    [self.tasks addObject:task];
}

-(void)play {
    if(self.tasks.count == 0)
        return;

    PlayTask* task = [self.tasks objectAtIndex:0];
    if([task isAudioTask]) {
        if(!self.useAvplayerForAudio) {
            NSError* err;
            if(!self.avAudioPlayer) {
                self.avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[task.mediaContent playUrl] error:&err];
            }
            if(!self.avAudioPlayer.playing)
                [self.avAudioPlayer play];
        }
        else {
            if([task.mediaContent isDownloaded]) {
                self.avplayer = [[AVPlayer alloc] initWithURL:[task.mediaContent playUrl]];
            }
            else {
                NSMutableDictionary * headers = [NSMutableDictionary dictionary];
                NSString* token = [Lockbox stringForKey:kOauthTokenKey];
                [headers setObject:token forKey:@"Authorization"];
                AVURLAsset * asset = [AVURLAsset URLAssetWithURL:[task.mediaContent playUrl] options:@{@"AVURLAssetHTTPHeaderFieldsKey" : headers}];
                AVPlayerItem * item = [AVPlayerItem playerItemWithAsset:asset];
                self.avplayer = [[AVPlayer alloc] initWithPlayerItem:item];
            }
            if([[UIDevice currentDevice] systemVersion].intValue>=10){
                self.avplayer.automaticallyWaitsToMinimizeStalling = NO;
            }
            [self.avplayer play];
        }
    }
    else if([task isVideoTask]) {
        if([task.mediaContent isDownloaded]) {
            self.avplayer = [[AVPlayer alloc] initWithURL:[task.mediaContent playUrl]];
        }
        else {
            NSMutableDictionary * headers = [NSMutableDictionary dictionary];
            NSString* token = [Lockbox stringForKey:kOauthTokenKey];
            [headers setObject:token forKey:@"Authorization"];
            AVURLAsset * asset = [AVURLAsset URLAssetWithURL:[task.mediaContent playUrl] options:@{@"AVURLAssetHTTPHeaderFieldsKey" : headers}];
            AVPlayerItem * item = [AVPlayerItem playerItemWithAsset:asset];
            self.avplayer = [[AVPlayer alloc] initWithPlayerItem:item];
            if([[UIDevice currentDevice] systemVersion].intValue>=10){
                self.avplayer.automaticallyWaitsToMinimizeStalling = NO;
            }
        }
        [self.avplayer play];
    }
}

-(void)pause
{
    PlayTask* task = [self.tasks objectAtIndex:0];
    if([task isAudioTask]) {
        [self.avAudioPlayer pause];
    }
    else if([task isVideoTask]) {
        self.avplayer = [[AVPlayer alloc] initWithURL:[task.mediaContent playUrl]];
    }
}

-(void)stop
{
    [self.avAudioPlayer stop];
    self.avAudioPlayer = nil;
    
    [self.avplayer pause];
    self.avplayer = nil;
    
}

-(CGFloat)currentTaskDuration {
    PlayTask* task = [self.tasks objectAtIndex:0];
    if([task isAudioTask]) {
        return self.avAudioPlayer.duration;
    }
    else if([task isVideoTask]) {
        return self.avplayer.currentItem.asset.duration.value / self.avplayer.currentItem.asset.duration.timescale;
    }
    return 0.;
}

-(CGFloat)currentTime {
    PlayTask* task = [self.tasks objectAtIndex:0];
    if([task isAudioTask]) {
        return self.avAudioPlayer.currentTime;
    }
    else if([task isVideoTask]) {
        return 0;
    }
    return 0.;
}

-(void)setCurrentTime:(CGFloat)currentTime {
    PlayTask* task = [self.tasks objectAtIndex:0];
    if([task isAudioTask]) {
        self.avAudioPlayer.currentTime = currentTime;
    }
    else if([task isVideoTask]) {
    }
}

-(BOOL)isPlaying {
    PlayTask* task = [self.tasks objectAtIndex:0];
    if([task isAudioTask]) {
        if(!self.useAvplayerForAudio)
            return self.avAudioPlayer.playing;
        else {
            if([[UIDevice currentDevice] systemVersion].intValue>=10){
                return self.avplayer.timeControlStatus == AVPlayerTimeControlStatusPlaying;
            }else{
                return self.avplayer.rate==1;
            }
        }
    }
    else if([task isVideoTask]) {
        if([[UIDevice currentDevice] systemVersion].intValue>=10){
            return self.avplayer.timeControlStatus == AVPlayerTimeControlStatusPlaying;
        }else{
            return self.avplayer.rate==1;
        }
    }
    return NO;
}
@end
