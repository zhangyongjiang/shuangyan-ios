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
        return;
    }
    if([player isPlaying:self.localMediaContent]) {
        [player stop];
    }
    else {
        [player setAttachedView:self];
        [player play];
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
