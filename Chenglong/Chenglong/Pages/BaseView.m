//
//  BaseView.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/5/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
