//
//  MediaPlayer.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 7/11/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "MediaPlayer.h"

@interface MediaPlayer()

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
    
    PlayTask* task = [self.tasks objectAtIndex:0];
    if(self.avplayer == nil) {
        self.avplayer = [[AVPlayer alloc] initWithURL:[task.mediaContent playUrl]];
        if([[UIDevice currentDevice] systemVersion].intValue>=10){
            self.avplayer.automaticallyWaitsToMinimizeStalling = NO;
        }
    }
    [self.avplayer play];
}

-(void)pause
{
    [self.avplayer pause];
}

-(void)stop
{
    [self.avplayer pause];
}

-(CGFloat)currentTaskDuration {
    return self.avplayer.currentItem.asset.duration.value / self.avplayer.currentItem.asset.duration.timescale;
}

-(CGFloat)currentTime {
    return self.avplayer.currentTime.value / self.avplayer.currentTime.timescale;
}

-(void)setCurrentTime:(CGFloat)currentTime {
}

-(BOOL)isPlaying {
    if([[UIDevice currentDevice] systemVersion].intValue>=10){
        return self.avplayer.timeControlStatus == AVPlayerTimeControlStatusPlaying;
    }else{
        return self.avplayer.rate==1;
    }
}
@end
