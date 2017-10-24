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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playingNotiHandler:) name:NotificationPlayStart object:nil];
    
    return self;
}

-(void)playingNotiHandler:(NSNotification*)noti
{
    PlayTask* pt = noti.object;
    if (self.controlView.hidden)
        return;
    WeakSelf(weakSelf)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.controlView.hidden = YES;
    });
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
