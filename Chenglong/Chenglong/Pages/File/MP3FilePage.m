//
//  MP3FilePage.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/8/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "MP3FilePage.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>


@interface MP3FilePage() {
    AVAudioPlayer *player;
}
@end

@implementation MP3FilePage

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    return self;
}

-(void)play {
    NSURL* url = [NSURL fileURLWithPath:self.offline];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [player play];
}
@end
