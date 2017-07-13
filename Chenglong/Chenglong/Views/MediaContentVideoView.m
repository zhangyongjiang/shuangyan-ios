//
//  MediaContentVideoView.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/11/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "MediaContentVideoView.h"
#import <AVFoundation/AVFoundation.h>

@interface MediaContentVideoView()
{
    BOOL playing;
}
@end

@implementation MediaContentVideoView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self addTarget:self action:@selector(clicked)];
    return self;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[AppDelegate appDelegate].sharedPlayer pause];
}

-(void)clicked {
    NSLog(@"clicked");
    if(playing)
        [[AppDelegate appDelegate].sharedPlayer pause];
    else
        [[AppDelegate appDelegate].sharedPlayer play];
    playing = !playing;
}

-(void)play {
    if(![self.localMediaContent isDownloaded]) {
        NSLog(@"no downloaded yet");
        return;
    }
    self.btnDownload.hidden = YES;
    playing = YES;
    
    NSURL* url = [NSURL fileURLWithPath:self.localMediaContent.filePath];
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
    [[AppDelegate appDelegate] addPlayerToView:self];
    [[AppDelegate appDelegate].sharedPlayer replaceCurrentItemWithPlayerItem:item];
    [[AppDelegate appDelegate].sharedPlayer play];
}

-(void)layoutSubviews {
    [super layoutSubviews];
}

-(BOOL)isPlaying {
    return playing;
}

@end
