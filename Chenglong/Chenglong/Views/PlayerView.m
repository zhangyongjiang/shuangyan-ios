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

@property(strong, nonatomic) UIView* coverView;

@end

@implementation PlayerView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    self.containerView = [MediaContentViewContailer new];
    [self addSubview:self.containerView];
    [self.containerView autoPinEdgesToSuperviewMargins];
    
    self.coverView = [UIView new];
    [self addSubview:self.coverView];
    [self.coverView autoPinEdgesToSuperviewMargins];
    [self.coverView addTarget:self action:@selector(coverViewClicked)];
    
    self.controlView = [PlayerControlView new];
    [self addSubview:self.controlView];
    [self.controlView autoPinEdgesToSuperviewMargins];
    [self.controlView addTarget:self action:@selector(coverViewClicked)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playingNotiHandler:) name:NotificationPlaying object:nil];
    
    return self;
}

-(void)coverViewClicked {
    self.controlView.hidden = !self.controlView.hidden;
}

-(void)playingNotiHandler:(NSNotification*)noti
{
    static BOOL hiding = NO;
    if (self.controlView.hidden || hiding)
        return;
    hiding = YES;
    WeakSelf(weakSelf)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if([MediaPlayer shared].isAvplayerPlaying)
            weakSelf.controlView.hidden = YES;
        hiding = NO;
    });
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
