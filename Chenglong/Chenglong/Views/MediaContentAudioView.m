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
}
@end

@implementation MediaContentAudioView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    return self;
}

-(void)setLocalMediaContent:(LocalMediaContent *)localMediaContent {
    [super setLocalMediaContent:localMediaContent];
    [self playAudio];
}

-(void)playAudio {
    if(![self.localMediaContent isDownloaded]) {
        NSLog(@"no downloaded yet");
        return;
    }
    NSURL* url = [NSURL fileURLWithPath:self.localMediaContent.filePath];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [player play];
}

@end
