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
-(NSString*)localFilePath;
-(NSString*)fileName;
-(NSString*)dirName;
-(int)expectedDownloadSize;
-(void)deleteFile;
-(CMTime)duration;


@end
