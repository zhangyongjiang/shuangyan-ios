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
        [player addPlayTask:task];
        [player play];
//        slider.maximumValue = [player currentTaskDuration];
        [self.btnDownload setTitle:@"暂停" forState: UIControlStateNormal];
        
        WeakSelf(weakSelf)
//        timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:weakSelf selector:@selector(checkPlayerStatus) userInfo:nil repeats:YES];

        return;
    }
    if([player isPlaying]) {
        [self.btnDownload setTitle:@"播放" forState: UIControlStateNormal];
        [player pause];
    }
    else {
        float total = [player currentTaskDuration];
        float current = [player currentTime];
        if((total-current)<0.001) {
            [player setCurrentTime:0];
        }
        [self.btnDownload setTitle:@"暂停" forState: UIControlStateNormal];
        [player play];
    }
}

-(void)checkPlayerStatus
{
    float total = [player currentTaskDuration];
    float current = [player currentTime];
    float progress = current / total;
    slider.value = player.currentTime;
    if(![player isPlaying]) {
        [self.btnDownload setTitle:@"播放" forState: UIControlStateNormal];
        if((total-current)<0.001) {
            [player setCurrentTime:0];
        }
    }
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
