//
//  ButtonNext.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 12/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "ButtonNext.h"

@implementation ButtonNext

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self addTarget:self action:@selector(btnClicked)];
    return self;
}

-(void)btnClicked {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPlayNext object:nil];
}

+(ButtonNext*)createBtnInSuperView:(UIView*)parent
{
    ButtonNext* btn = [ButtonNext new];
    btn.contentMode = UIViewContentModeScaleAspectFit;
    btn.image = [UIImage imageNamed:@"ic_skip_next_white"];
    [parent addSubview:btn];
    [btn autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [btn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [btn autoSetDimensionsToSize:CGSizeMake(btnsize, btnsize)];
    return btn;
}

@end
