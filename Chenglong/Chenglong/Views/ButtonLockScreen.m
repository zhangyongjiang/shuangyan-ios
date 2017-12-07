//
//  ButtonLockScreen.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 12/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "ButtonLockScreen.h"

@implementation ButtonLockScreen

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self addTarget:self action:@selector(btnClicked)];
    return self;
}

-(void)btnClicked {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLockScreen object:nil];
}

+(ButtonLockScreen*)createBtnInSuperView:(UIView*)parent withIcon:(NSString *)imageName
{
    ButtonLockScreen* btn = [ButtonLockScreen new];
    btn.contentMode = UIViewContentModeScaleAspectFit;
    btn.image = [UIImage imageNamed:imageName];
    [parent addSubview:btn];
    [btn autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [btn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [btn autoSetDimensionsToSize:CGSizeMake(btnsize, btnsize)];
    return btn;
}

@end
