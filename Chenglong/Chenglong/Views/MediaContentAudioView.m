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
    BOOL playing;
    NSTimer* timer;
    UISlider* slider;
}
@end

@implementation MediaContentAudioView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    slider = [UISlider new];
    slider.userInteractionEnabled = YES;
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];

    [self addSubview:slider];
    
    return self;
}

-(void)dealloc
{
    [timer invalidate];
    timer = nil;
    [player stop];
    player = nil;
}

-(void)play {
    NSURL* url = [NSURL fileURLWithPath:self.mediaContent.filePath];
    if(![self.mediaContent isDownloaded]) {
        url = [NSURL URLWithString:self.mediaContent.url];
    }
    if(!player) {
        player = [MediaPlayer shared];
        PlayTask* task = [[PlayTask alloc] init];
        task.mediaContent = self.mediaContent;
        [player addPlayTask:task];
        [player play];
        slider.maximumValue = [player currentTaskDuration];
        [self.btnDownload setTitle:@"暂停" forState: UIControlStateNormal];
        playing = YES;
        
        WeakSelf(weakSelf)
        timer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:weakSelf selector:@selector(checkPlayerStatus) userInfo:nil repeats:YES];

        return;
    }
    if(playing) {
        [self.btnDownload setTitle:@"播放" forState: UIControlStateNormal];
        [player pause];
    }
    else {
        [self.btnDownload setTitle:@"暂停" forState: UIControlStateNormal];
        [player play];
    }
    playing = !playing;
}

-(void)checkPlayerStatus
{
    float total = [player currentTaskDuration];
    float current = [player currentTime];
    float progress = current / total;
    if (current < 0.0001) {
        player.currentTime = 0;
        if(self.repeat) {
            [player play];
            playing = YES;
        }
        else {
            playing = NO;
        }
    }
    slider.value = player.currentTime;
}

-(void)stop
{
    [player stop];
    player = nil;
    [timer invalidate];
    timer = nil;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    slider.width = self.width * 0.75f;
    slider.bottom = self.height - Margin;
    slider.x = self.width * 0.125f;
}

-(void)sliderValueChanged:(UISlider *)sender {
    player.currentTime = sender.value;
}

-(BOOL)isPlaying
{
    return [player isPlaying];
}
@end
