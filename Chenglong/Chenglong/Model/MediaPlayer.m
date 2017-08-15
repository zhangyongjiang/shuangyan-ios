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
    
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"course://%@", task.localMediaContent.localFilePath]];
        AVURLAsset* asset = [AVURLAsset assetWithURL:url];
        [asset.resourceLoader setDelegate:task.localMediaContent queue:dispatch_get_main_queue()];
        NSArray *keys = @[@"playable", @"tracks",@"duration" ];
        [asset loadValuesAsynchronouslyForKeys:keys completionHandler:^()
         {
             // make sure everything downloaded properly
             for (NSString *thisKey in keys) {
                 NSError *error = nil;
                 AVKeyValueStatus keyStatus = [asset statusOfValueForKey:thisKey error:&error];
                 if (keyStatus == AVKeyValueStatusFailed) {
                     return ;
                 }
             }
             
             AVPlayerItem *item = [[AVPlayerItem alloc] initWithAsset:asset];
             if(self.avplayer == nil) {
                 dispatch_async(dispatch_get_main_queue(), ^ {
                     self.avplayer = [[AVQueuePlayer alloc] initWithPlayerItem:item];
                     [self setAttachedView:self.attachedView];
                     if([[UIDevice currentDevice] systemVersion].intValue>=10){
                         self.avplayer.automaticallyWaitsToMinimizeStalling = NO;
                     }
                     [self.avplayer play];
                 });
             }
             else {
                 dispatch_async(dispatch_get_main_queue(), ^ {
                     [self.avplayer replaceCurrentItemWithPlayerItem:item];
                     [self.avplayer play];
                 });
             }
         }];
}

-(void)play {
    [self.avplayer play];
}

-(AVPlayerItem*)getPlayItemForMediaContent:(LocalMediaContent*)mc
{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"course://%@", mc.localFilePath]];
    AVURLAsset* asset = [AVURLAsset assetWithURL:url];
    [asset.resourceLoader setDelegate:mc queue:dispatch_get_main_queue()];
    
//    AVPlayerItem* item = [[AVPlayerItem alloc] initWithAsset:asset];
    NSArray *keys = @[@"playable", @"tracks",@"duration" ];
    AVPlayerItem* item = [[AVPlayerItem alloc] initWithAsset:asset automaticallyLoadedAssetKeys:keys];
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
//                    self.avplayer = nil;
                    self.current = -1;
                }
                else {
                    task = [self.tasks objectAtIndex:self.current];
                    AVPlayerItem* item = [self getPlayItemForMediaContent:task.localMediaContent];
                    [self.avplayer replaceCurrentItemWithPlayerItem:item];
//                    [self.avplayer insertItem:item afterItem:nil];
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

-(void)setAttachedView:(UIView *)attachedView {
    _attachedView = attachedView;
    AVPlayerLayer* layer = [AVPlayerLayer playerLayerWithPlayer:self.avplayer];
    layer.frame = attachedView.bounds;
    [attachedView.layer addSublayer:layer];
    layer.backgroundColor = [UIColor clearColor].CGColor;
    [layer setVideoGravity:AVLayerVideoGravityResizeAspect];
}
@end
