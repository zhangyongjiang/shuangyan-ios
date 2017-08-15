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
    self.current = 0;
    return self;
}

-(void)addPlayTask:(PlayTask *)task {
    [self.tasks addObject:task];
    if(self.current == -1)
        self.current = 0;
}

-(void)playTask:(PlayTask *)task {
    [self.tasks addObject:task];
    self.current = self.tasks.count - 1;
    if(self.avplayer == nil) {
        [self createPlayer];
    }
    else {
        task = [self.tasks objectAtIndex:self.current];
        AVPlayerItem* item = [self getPlayItemForMediaContent:task.localMediaContent];
        [self.avplayer replaceCurrentItemWithPlayerItem:item];
    }
    [self.avplayer play];
}

-(void)play {
    if(self.tasks.count == 0)
        return;
    [self createPlayer];
    [self.avplayer play];
}

-(void)createPlayer
{
    if(self.avplayer == nil) {
        PlayTask* task = [self.tasks objectAtIndex:self.current];
        if(false) {
            self.avplayer = [[AVPlayer alloc] initWithURL:[task.localMediaContent playUrl]];
        }
        else {
            AVPlayerItem* item = [self getPlayItemForMediaContent:task.localMediaContent];
            self.avplayer = [[AVPlayer alloc] initWithPlayerItem:item];
        }
        
        if([[UIDevice currentDevice] systemVersion].intValue>=10){
            self.avplayer.automaticallyWaitsToMinimizeStalling = NO;
        }
    }
}

-(AVPlayerItem*)getPlayItemForMediaContent:(LocalMediaContent*)mc
{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"course://%@", mc.localFilePath]];
    AVURLAsset* asset = [AVURLAsset assetWithURL:url];
    [asset.resourceLoader setDelegate:mc queue:dispatch_get_main_queue()];
//    NSArray *keys = @[@"playable"];
    AVPlayerItem* item = [[AVPlayerItem alloc] initWithAsset:asset /*automaticallyLoadedAssetKeys:keys*/];
    return item;
}

-(void)resume
{
    [self.avplayer play];
}

-(void)pause
{
    [self.avplayer pause];
}

-(void)removeTask:(LocalMediaContent *)mc
{
    for (int i=0; i<self.tasks.count; i++) {
        PlayTask* task = [self.tasks objectAtIndex:0];
        if([task.localMediaContent.url isEqualToString:mc.url]) {
            [self.tasks removeObjectAtIndex:i];
            if(i==self.current) {
                [self.avplayer pause];
                self.current ++;
                if(self.current >= self.tasks.count) {
                    self.avplayer = nil;
                    self.current = -1;
                }
                else {
                    task = [self.tasks objectAtIndex:self.current];
                    AVPlayerItem* item = [AVPlayerItem playerItemWithURL:[task.localMediaContent playUrl]];
                    [self.avplayer replaceCurrentItemWithPlayerItem:item];
                }
            }
            break;
        }
    }
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
    int32_t timeScale = self.avplayer.currentItem.asset.duration.timescale;
    CMTime seektime=CMTimeMakeWithSeconds(currentTime, timeScale);
    [self.avplayer seekToTime:seektime];
}

-(BOOL)isPlaying {
    if([[UIDevice currentDevice] systemVersion].intValue>=10){
        return self.avplayer.timeControlStatus == AVPlayerTimeControlStatusPlaying;
    }else{
        return self.avplayer.rate==1;
    }
}
@end
