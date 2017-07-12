//
//  MediaPlayer.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 7/11/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayTask.h"

@interface MediaPlayer : NSObject

+(MediaPlayer*)shared;

@property(assign, nonatomic)BOOL repeat;

-(void)addPlayTask:(PlayTask*)task;
-(void)play;

@end
