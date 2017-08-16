//
//  LocalMediaContentShard.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 8/13/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalMediaContent.h"

@interface LocalMediaContentShard : NSObject

@property(strong, nonatomic) LocalMediaContent* localMediaContent;
@property(assign, nonatomic) int shard;

-(id)initWithLocalMediaContent:(LocalMediaContent*)localMediaContent andShard:(int)shard;

-(NSString*)url;
-(BOOL)isDownloaded;
-(int)expectedDownloadSize;
-(void)deleteFile;
-(CMTime)duration;
-(NSData*)data;

- (void)downloadWithProgressBlock:(void(^)(LocalMediaContentShard* shard, CGFloat progress))progressBlock
                              completionBlock:(void(^)(LocalMediaContentShard* shard, BOOL completed))completionBlock
                         enableBackgroundMode:(BOOL)backgroundMode;

@end
