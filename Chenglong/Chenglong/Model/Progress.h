//
//  Progress.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 10/1/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Progress : NSObject

@property(assign, nonatomic) long expected;
@property(assign, nonatomic) long current;
@property(strong, nonatomic) LocalMediaContent* localMediaContent;

-(CGFloat)progress;

@end
