//
//  PlayerView.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 10/24/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "PlayerView.h"

@implementation PlayerView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    self.containerView = [MediaContentViewContailer new];
    [self addSubview:self.containerView];
    [self.containerView autoPinEdgesToSuperviewMargins];
    
    self.controlView = [PlayerControlView new];
    [self addSubview:self.controlView];
    [self.controlView autoPinEdgesToSuperviewMargins];
    
    return self;
}

@end
