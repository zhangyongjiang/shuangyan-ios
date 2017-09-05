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
}
@end

@implementation MediaContentAudioView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [player stop];
    player = nil;
}

-(void)play {
    if(!player) {
        player = [MediaPlayer shared];
        [player setAttachedView:self];
        PlayTask* task = [[PlayTask alloc] init];
        task.localMediaContent = self.localMediaContent;
        [player playTask:task];
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
