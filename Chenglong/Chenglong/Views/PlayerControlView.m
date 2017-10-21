//
//  PlayerControlView.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 8/23/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "PlayerControlView.h"

@interface PlayerControlView()


@end

@implementation PlayerControlView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
    
    self.btnPlayPause = [UIImageView new];
    self.btnPlayPause.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.btnPlayPause];
    [self.btnPlayPause autoCenterInSuperview];
    [self.btnPlayPause autoSetDimensionsToSize:CGSizeMake(60, 60)];
    
    [self showPlayButton];
    
    return self;
}

-(void)showPlayButton
{
    self.btnPlayPause.image = [UIImage imageNamed:@"ic_play_arrow"];
}

-(void)showPauseButton
{
    self.btnPlayPause.image = [UIImage imageNamed:@"audio-pause"];
}

-(UIImageView*)makeSmallButton
{
    return NULL;
}
@end
