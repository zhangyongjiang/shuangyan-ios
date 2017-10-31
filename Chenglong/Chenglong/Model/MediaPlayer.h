//
//  MediaPlayer.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 7/11/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayTask.h"
#import <AVFoundation/AVFoundation.h>

#define RepeatNone  0
#define RepeatOne   1
#define RepeatAll   2

@interface MediaPlayer : NSObject

+(MediaPlayer*)shared;

@property(assign, nonatomic)CGFloat currentTime;
@property(weak, nonatomic) UIView* attachedView;
@property (assign, nonatomic) BOOL repeat;

-(void)playTask:(PlayTask *)task;
-(void)pause;
-(void)resume;
-(void)stop;
-(BOOL)isPlaying:(LocalMediaContent*)mc;
-(BOOL)isAvplayerPlaying;

-(CGFloat)currentTaskDuration;

@end
