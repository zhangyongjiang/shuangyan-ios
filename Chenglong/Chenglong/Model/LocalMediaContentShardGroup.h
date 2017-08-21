//
//  LocalMediaContentShardGroup.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 8/19/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalMediaContentShard.h"

@interface LocalMediaContentShardGroup : NSObject

-(id)initWithShards:(NSMutableArray<LocalMediaContentShard*>*)shards;
-(void)downloadWithCompletionBlock:(CompletionCallback)completionBlock;

@end
