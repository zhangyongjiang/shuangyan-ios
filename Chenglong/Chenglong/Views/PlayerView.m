//
//  PlayerView.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 10/24/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "PlayerView.h"
#import "MediaPlayer.h"

@interface PlayerView()


@end

@implementation PlayerView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    self.containerView = [MediaContentViewContailer new];
    [self addSubview:self.containerView];
    [self.containerView autoPinEdgesToSuperviewMargins];
        
    return self;
}

-(void) play
{
    self.containerView.localMediaContent = self.localMediaContent;
    [self.containerView play];
}

-(void) stop
{
    [self.containerView stop];
}

@end
