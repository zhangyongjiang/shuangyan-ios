//
//  Progress.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 10/1/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "Progress.h"

@implementation Progress

-(CGFloat)progress
{
    return (CGFloat)self.current / (CGFloat)self.expected;
}

@end
