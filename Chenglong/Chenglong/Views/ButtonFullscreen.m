//
//  ButtonFullscreen.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 12/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "ButtonFullscreen.h"

@implementation ButtonFullscreen

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self addTarget:self action:@selector(btnClicked)];
    return self;
}

-(void)btnClicked {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationFullscreen object:nil];
}

+(ButtonFullscreen*)createBtnInSuperView:(UIView*)parent withIcon:(NSString *)imageName
{
    ButtonFullscreen* btn = [ButtonFullscreen new];
    btn.contentMode = UIViewContentModeScaleAspectFit;
    btn.image = [UIImage imageNamed:imageName];
    [parent addSubview:btn];
    [btn autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [btn autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [btn autoSetDimensionsToSize:CGSizeMake(btnsize, btnsize)];
    return btn;
}

@end
