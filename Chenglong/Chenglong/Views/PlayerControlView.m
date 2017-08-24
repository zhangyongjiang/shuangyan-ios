//
//  PlayerControlView.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 8/23/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "PlayerControlView.h"

@interface PlayerControlView()

@property(strong, nonatomic) UIImageView* btn;

@end

@implementation PlayerControlView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor colorFromRGBA:0x00000088];
    
    self.btn = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.btn.contentMode = UIViewContentModeCenter;
    [self addSubview:self.btn];
    [self.btn autoCenterInSuperview];
    [self setPlayButton];
    
    return self;
}

-(void)setPlayButton
{
    self.btn.image = [UIImage imageNamed:@"button-play"];
}

@end
