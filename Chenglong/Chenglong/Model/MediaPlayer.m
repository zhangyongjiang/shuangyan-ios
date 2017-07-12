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
    return self;
}

-(void)addPlayTask:(PlayTask *)task {
    [self.tasks addObject:task];
}

-(void)play {
    if(self.tasks.count == 0)
        return;
    
    [self.avAudioPlayer stop];
    self.avAudioPlayer = nil;
    
    [self.avplayer pause];
    self.avplayer = nil;
    
    PlayTask* task = [self.tasks objectAtIndex:0];
    if([task isAudioTask]) {
        NSError* err;
        self.avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[task.mediaContent localUrl] error:&err];
    }
    else if([task isVideoTask]) {
    }
}
@end
