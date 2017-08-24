//
//  LocalMediaContentShardGroup.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 8/19/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "LocalMediaContentShardGroup.h"

@interface LocalMediaContentShardGroup()

@property(strong, nonatomic) NSMutableArray<LocalMediaContentShard*>* shards;

@end

@implementation LocalMediaContentShardGroup

-(id)initWithShards:(NSMutableArray<LocalMediaContentShard *> *)shards {
    self = [super init];
    self.shards = shards;
    return self;
}

-(void)downloadWithCompletionBlock:(CompletionCallback)completionBlock
{
    while(self.shards.count>0) {
        LocalMediaContentShard* shard = [self.shards objectAtIndex:0];
        if(shard.isDownloaded)
            [self.shards removeObjectAtIndex:0];
        else
            break;
    }
    if(self.shards.count == 0) {
        if(completionBlock != NULL) {
            completionBlock(YES);
        }
        return;
    }
    __block CompletionCallback block = completionBlock;
    LocalMediaContentShard* shard = [self.shards objectAtIndex:0];
    [shard downloadWithProgressBlock:^(LocalMediaContentShard *shard, CGFloat progress) {
        
    } completionBlock:^(LocalMediaContentShard *shard, BOOL completed) {
        NSLog(@"========LocalMediaContentShardGroup shard %d downloaded %i", shard.shard, completed);
        if(!completed) {
            if(block != NULL) {
                block(completed);
            }
            return;
        }
        if(self.shards.count != 0) {
            [self downloadWithCompletionBlock:block];
        }
    } enableBackgroundMode:YES];
}

@end
