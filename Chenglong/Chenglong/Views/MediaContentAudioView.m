//
//  MediaContentAudioView.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/10/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "MediaContentAudioView.h"
#import <AVFoundation/AVFoundation.h>

@interface MediaContentAudioView()
{
    MediaPlayer *player;
    NSTimer* timer;
}
@end

@implementation MediaContentAudioView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

-(void)dealloc
{
    [self destroy];
}

-(void)destroy
{
    [timer invalidate];
    timer = nil;
    [player stop];
    [player removeTask:self.localMediaContent];
    player = nil;
}

-(void)play {
    if(!player) {
        player = [MediaPlayer shared];
        PlayTask* task = [[PlayTask alloc] init];
        task.localMediaContent = self.localMediaContent;
        [player playTask:task];
        [player setAttachedView:self];
//        [self.btnDownload setTitle:@"暂停" forState: UIControlStateNormal];
        
//        WeakSelf(weakSelf)
//        timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:weakSelf selector:@selector(checkPlayerStatus) userInfo:nil repeats:YES];
//
        return;
    }
    if([player isPlaying:self.localMediaContent]) {
//        [self.btnDownload setTitle:@"播放" forState: UIControlStateNormal];
        [player stop];
    }
    else {
        float total = [player currentTaskDuration];
        float current = [player currentTime];
        if((total-current)<0.001) {
            [player setCurrentTime:0];
        }
//        [self.btnDownload setTitle:@"暂停" forState: UIControlStateNormal];
        [player setAttachedView:self];
        [player play];
    }
}

-(void)checkPlayerStatus
{
    float total = [player currentTaskDuration];
    float current = [player currentTime];
    float progress = current / total;
    if(![player isPlaying:self.localMediaContent]) {
//        [self.btnDownload setTitle:@"播放" forState: UIControlStateNormal];
        if((total-current)<0.001) {
            [player setCurrentTime:0];
        }
    }
}

-(BOOL)isPlaying
{
    return [player isPlaying:self.localMediaContent];
}

-(void)stop
{
    [player removeTask:self.localMediaContent];
}
@end
