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
    return self;
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
        [self.btnDownload setTitle:@"暂停" forState: UIControlStateNormal];
        playing = YES;
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

@end
