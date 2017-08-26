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
    self.backgroundColor = [UIColor colorFromRGBA:0x00000088];
    
    self.btn = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.btn.contentMode = UIViewContentModeCenter;
    self.btn.userInteractionEnabled = YES;
    [self addSubview:self.btn];
    [self.btn autoCenterInSuperview];
    [self showPlayButton];
    
    return self;
}

-(void)showPlayButton
{
    self.btn.image = [UIImage imageNamed:@"audio-play"];
}

-(void)showPauseButton
{
    self.btn.image = [UIImage imageNamed:@"audio-pause"];
}

@end
