//
//  ButtonPrev.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 12/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "ButtonPrev.h"

@implementation ButtonPrev

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self addTarget:self action:@selector(btnPrevClicked)];
    return self;
}

-(void)btnPrevClicked {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPlayPrev object:nil];
}

+(ButtonPrev*)createBtnInSuperView:(UIView*)parent withIcon:(NSString*)imageName
{
    ButtonPrev* btnPrev = [ButtonPrev new];
    btnPrev.contentMode = UIViewContentModeScaleAspectFit;
    btnPrev.image = [UIImage imageNamed:imageName];
    [parent addSubview:btnPrev];
    [btnPrev autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [btnPrev autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [btnPrev autoSetDimensionsToSize:CGSizeMake(btnsize, btnsize)];
    return btnPrev;
}

@end
