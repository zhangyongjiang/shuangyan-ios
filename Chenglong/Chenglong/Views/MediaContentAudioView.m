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
}
@end

@implementation MediaContentAudioView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self addTarget:self action:@selector(clicked)];
    return self;
}

-(void)clicked {
    NSLog(@"clicked");
    if(playing)
        [player pause];
    else
        [player play];
    playing = !playing;
}

-(void)play {
    if(![self.localMediaContent isDownloaded]) {
        NSLog(@"no downloaded yet");
        return;
    }
    if(!player) {
        NSURL* url = [NSURL fileURLWithPath:self.localMediaContent.filePath];
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        [player play];
        playing = YES;
        self.btnDownload.hidden = YES;
        return;
    }
}

@end
