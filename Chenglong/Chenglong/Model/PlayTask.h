//
//  PlayTask.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 7/11/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayTask : NSObject

@property(strong, nonatomic)LocalMediaContent* localMediaContent;
@property(assign, nonatomic)BOOL repeat;
@property(strong, nonatomic)AVPlayerItem* item;

-(BOOL)isAudioTask;
-(BOOL)isVideoTask;

@end
