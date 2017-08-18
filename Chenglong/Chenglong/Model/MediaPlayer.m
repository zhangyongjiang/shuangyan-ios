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
    
    if(true) {
//        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"course://%@", task.localMediaContent.localFilePath]];
//        NSURL* url = [NSURL URLWithString:@"http://bbzjprivate.oss-cn-shanghai.aliyuncs.com/ALIYUNPRIVATE/58/de/53/32c8a9446a912ccdd3e823e767.mp4"];
//        NSURL* url = [NSURL URLWithString:@"http://api.babazaojiao.com/user-service/download?path=/ALIYUNPRIVATE/2b/80/7d/fb6ee74638be0c159651858663.mp4&access_token=8294036c-90ec-41a7-92ab-3cfe94849c5f"];
        NSString* ustr = task.localMediaContent.url;
        NSURL* url = NULL;
        if([ustr containsString:@"aliyuncs.com"])
            url = [NSURL URLWithString:ustr];
        else
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@&access_token=%@", ustr, AppDelegate.userAccessToken]];
        NSLog(@"play content at %@", url);
        
        AVURLAsset* asset = [AVURLAsset assetWithURL:url];
//        [asset.resourceLoader setDelegate:task.localMediaContent queue:dispatch_get_main_queue()];
        NSArray *keys = @[@"playable", @"tracks",@"duration" ];
        [asset loadValuesAsynchronouslyForKeys:keys completionHandler:^()
         {
             // make sure everything downloaded properly
             for (NSString *thisKey in keys) {
                 NSError *error = nil;
                 AVKeyValueStatus keyStatus = [asset statusOfValueForKey:thisKey error:&error];
                 if (keyStatus == AVKeyValueStatusFailed) {
                     NSLog(@"AVKeyValueStatusFailed for key %@", thisKey);
                     return ;
                 }
             }
             
             AVPlayerItem *item = [[AVPlayerItem alloc] initWithAsset:asset];
             PlayTask* task = [self.tasks objectAtIndex:self.current];
             task.item = item;
             if(self.avplayer == nil) {
                 dispatch_async(dispatch_get_main_queue(), ^ {
                     self.avplayer = [[AVQueuePlayer alloc] initWithPlayerItem:item];
                     if([[UIDevice currentDevice] systemVersion].intValue>=10){
                         self.avplayer.automaticallyWaitsToMinimizeStalling = NO;
                     }
                     [self.avplayer play];
                     [self setAttachedView:self.attachedView];
                 });
             }
             else {
                 dispatch_async(dispatch_get_main_queue(), ^ {
                     [self.avplayer replaceCurrentItemWithPlayerItem:item];
                     [self.avplayer play];
                     [self setAttachedView:self.attachedView];
                 });
             }
         }];
    } else {
        PlayTask* task = [self.tasks objectAtIndex:self.current];
        NSURL* url = [NSURL fileURLWithPath:task.localMediaContent.localFilePath];
        AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
        task.item = item;
        if(self.avplayer == nil) {
            dispatch_async(dispatch_get_main_queue(), ^ {
                self.avplayer = [[AVQueuePlayer alloc] initWithPlayerItem:item];
                if([[UIDevice currentDevice] systemVersion].intValue>=10){
                    self.avplayer.automaticallyWaitsToMinimizeStalling = NO;
                }
                [self.avplayer play];
                [self setAttachedView:self.attachedView];
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self.avplayer replaceCurrentItemWithPlayerItem:item];
                [self.avplayer play];
                [self setAttachedView:self.attachedView];
            });
        }
    }
}

-(void)play {
    [self.avplayer play];
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
            [self.avplayer removeItem:task.item];
            if(i==self.current) {
                [self.avplayer pause];
                self.current ++;
                if(self.current >= self.tasks.count) {
//                    self.avplayer = nil;
                    self.current = -1;
                }
                else {
                    task = [self.tasks objectAtIndex:self.current];
                    
                    NSString* ustr = task.localMediaContent.url;
                    NSURL* url = NULL;
                    if([ustr containsString:@"aliyuncs.com"])
                        url = [NSURL URLWithString:ustr];
                    else
                        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@&access_token=%@", ustr, AppDelegate.userAccessToken]];
                    NSLog(@"play content at %@", url);
                    
                    AVURLAsset* asset = [AVURLAsset assetWithURL:url];
                    //        [asset.resourceLoader setDelegate:task.localMediaContent queue:dispatch_get_main_queue()];
                    NSArray *keys = @[@"playable", @"tracks",@"duration" ];
                    [asset loadValuesAsynchronouslyForKeys:keys completionHandler:^()
                     {
                         // make sure everything downloaded properly
                         for (NSString *thisKey in keys) {
                             NSError *error = nil;
                             AVKeyValueStatus keyStatus = [asset statusOfValueForKey:thisKey error:&error];
                             if (keyStatus == AVKeyValueStatusFailed) {
                                 NSLog(@"AVKeyValueStatusFailed for key %@", thisKey);
                                 return ;
                             }
                         }
                         
                         AVPlayerItem *item = [[AVPlayerItem alloc] initWithAsset:asset];
                         PlayTask* task = [self.tasks objectAtIndex:self.current];
                         task.item = item;
                         
                         [self.avplayer replaceCurrentItemWithPlayerItem:item];
                         //                    [self.avplayer insertItem:item afterItem:nil];
                     }];

                    
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
    PlayTask* task = [self.tasks objectAtIndex:self.current];
    CMTime t = task.localMediaContent.duration;
    return t.value / t.timescale;
}

-(CGFloat)currentTime {
    if(self.avplayer.currentTime.timescale != 0)
        return self.avplayer.currentTime.value / self.avplayer.currentTime.timescale;
    else
        return 0;
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
