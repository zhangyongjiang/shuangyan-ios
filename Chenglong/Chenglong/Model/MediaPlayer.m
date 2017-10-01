//
//  MediaPlayer.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 7/11/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "MediaPlayer.h"
#import "TWRDownloadManager.h"

@interface MediaPlayer()

@property (strong, nonatomic) AVPlayer* avplayer;
@property (strong, nonatomic) AVPlayerLayer* layer;
@property (strong, nonatomic) UISlider* slider;
@property (strong, nonatomic) id timeObserverToken;
@property (assign, nonatomic) BOOL backgroundMode;
@property (strong, nonatomic) PlayTask* playTask;

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
    
    self.avplayer = [[AVPlayer alloc] init];
    self.layer = [AVPlayerLayer playerLayerWithPlayer:self.avplayer];
    if([[UIDevice currentDevice] systemVersion].intValue>=10){
        self.avplayer.automaticallyWaitsToMinimizeStalling = NO;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];

    CMTime interval = CMTimeMake(1, 10);
    WeakSelf(weakSelf)
    self.timeObserverToken = [self.avplayer addPeriodicTimeObserverForInterval:interval queue:NULL usingBlock:^(CMTime time) {
        [weakSelf playerNoti:time];
    }];
    
    self.slider = [UISlider new];
    self.slider.userInteractionEnabled = YES;
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(background:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(foreground:) name:UIApplicationWillEnterForegroundNotification object:nil];

    return self;
}

-(void)playerNoti:(CMTime) time
{
    if([self isAvplayerPlaying]) {
       [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPlaying object:self.playTask];
        self.slider.hidden = YES;
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPlayPaused object:self.playTask];
        self.slider.hidden = NO;
    }
    if(self.slider.maximumValue < 0.000001)
        self.slider.maximumValue = self.currentTaskDuration;
    self.slider.value = self.currentTime;
}

-(void)playTask:(PlayTask *)task {
    self.playTask = task;

    NSString* ustr = task.localMediaContent.url;
    NSURL* url = NULL;
    BOOL useResourceLoader = YES;
    if(useResourceLoader) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"course://%@", task.localMediaContent.localFilePath]];
    }
    else {
        if([ustr containsString:@"aliyuncs.com"])
            url = [NSURL URLWithString:ustr];
        else
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@&access_token=%@", ustr, AppDelegate.userAccessToken]];
    }
    NSLog(@"play content at %@", url);

        __block AVURLAsset* asset = [AVURLAsset assetWithURL:url];
        [asset.resourceLoader setDelegate:task.localMediaContent queue:TWRDownloadManager.queue];
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
             
             __block AVPlayerItem *item = [[AVPlayerItem alloc] initWithAsset:asset];
             self.slider.maximumValue = self.currentTaskDuration;
             __block PlayTask* task = self.playTask;
             task.item = item;
             dispatch_async(dispatch_get_main_queue(), ^ {
                 [self.avplayer replaceCurrentItemWithPlayerItem:item];
                 [self.avplayer play];
                 [self setAttachedView:self.attachedView];
                 [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPlayStart object:task];
             });
         }];
}

-(void)play {
    NSLog(@"avplayer play");
    [self.avplayer play];
}

-(void)stop
{
    [self.avplayer replaceCurrentItemWithPlayerItem:nil];
}

-(void)resume
{
    [self.avplayer play];
}

-(void)pause
{
    [self.avplayer pause];
}

-(CGFloat)currentTaskDuration {
    CMTime t = self.avplayer.currentItem.duration;
    if(t.timescale > 0)
        return t.value / t.timescale;
    
    t = self.playTask.localMediaContent.duration;
    return t.value / t.timescale;
}

-(CGFloat)currentTime {
    if(self.avplayer.currentTime.timescale != 0)
        return ((CGFloat)self.avplayer.currentTime.value) / ((CGFloat)self.avplayer.currentTime.timescale);
    else
        return 0;
}

-(void)setCurrentTime:(CGFloat)currentTime {
    int32_t timeScale = self.avplayer.currentItem.asset.duration.timescale;
    CMTime seektime=CMTimeMakeWithSeconds(currentTime, timeScale);
    [self.avplayer seekToTime:seektime];
    self.slider.value = currentTime;
}

-(BOOL)isPlaying:(LocalMediaContent*)mc {
    if(![self.playTask.localMediaContent.path isEqualToString:mc.path])
        return NO;

    return YES;
}

-(BOOL)isAvplayerPlaying
{
    if([[UIDevice currentDevice] systemVersion].intValue>=10){
        return self.avplayer.timeControlStatus == AVPlayerTimeControlStatusPlaying;
    }else{
        return self.avplayer.rate==1;
    }
}

-(void)setAttachedView:(UIView *)attachedView {
    if(_attachedView == attachedView) {
        if(self.backgroundMode)return;
        self.layer.frame = attachedView.bounds;
        [self.slider removeFromSuperview];
        self.slider.width = attachedView.width * 0.8f;
        self.slider.bottom = attachedView.height - Margin;
        self.slider.x = attachedView.width * 0.1f;
        [attachedView addSubview:self.slider];
        return;
    }
    _attachedView = attachedView;
    if(self.backgroundMode)return;
    [self.layer removeFromSuperlayer];
    self.layer.frame = attachedView.bounds;
    [attachedView.layer addSublayer:self.layer];
    self.layer.backgroundColor = [UIColor clearColor].CGColor;
    [self.layer setVideoGravity:AVLayerVideoGravityResizeAspect];
    
    [self.slider removeFromSuperview];
    self.slider.width = attachedView.width * 0.8f;
    self.slider.bottom = attachedView.height - Margin;
    self.slider.x = attachedView.width * 0.1f;
    [attachedView addSubview:self.slider];
}

-(void)background:(NSNotification*)noti
{
    self.backgroundMode = YES;
    [self.layer removeFromSuperlayer];
    self.layer = nil;
}

-(void)foreground:(NSNotification*)noti
{
    self.backgroundMode = NO;
    self.layer = [AVPlayerLayer playerLayerWithPlayer:self.avplayer];
    [self.attachedView.layer addSublayer:self.layer];
    self.layer.frame = self.attachedView.bounds;
    self.layer.backgroundColor = [UIColor clearColor].CGColor;
    [self.layer setVideoGravity:AVLayerVideoGravityResizeAspect];
}

-(void)playerDidFinishPlaying:(NSNotification*)noti
{
    NSLog(@"playerDidFinishPlaying");
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPlayEnd object:self.playTask];
    self.slider.hidden = NO;
}

-(void)sliderValueChanged:(UISlider *)sender {
    [self setCurrentTime:sender.value];
}

@end
