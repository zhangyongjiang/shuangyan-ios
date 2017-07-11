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
    AVAudioPlayer *player;
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
    NSURL* url = [NSURL fileURLWithPath:self.localMediaContent.filePath];
    if(![self.localMediaContent isDownloaded]) {
        url = [NSURL URLWithString:self.localMediaContent.mediaContent.url];
    }
    if(!player) {
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        [player play];
        slider.maximumValue = player.duration;
        [self.btnDownload setTitle:@"暂停" forState: UIControlStateNormal];
        playing = YES;
        
        timer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(checkPlayerStatus) userInfo:nil repeats:YES];

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
    float total = player.duration;
    float current = player.currentTime;
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
