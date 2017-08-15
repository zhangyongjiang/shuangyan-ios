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

@interface MediaPlayer : NSObject

+(MediaPlayer*)shared;

@property(assign, nonatomic)BOOL repeat;
@property(assign, nonatomic)CGFloat currentTime;
@property (strong, nonatomic) AVQueuePlayer* avplayer;
@property(weak, nonatomic) UIView* attachedView;

-(void)addPlayTask:(PlayTask*)task;
-(void)playTask:(PlayTask *)task;
-(void)play;
-(void)pause;
-(void)resume;
-(void)stop;
-(BOOL)isPlaying;
-(void)removeTask:(LocalMediaContent*)mc;

-(CGFloat)currentTaskDuration;

@end
