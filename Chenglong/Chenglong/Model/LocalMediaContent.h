//
//  LocalMediaContent.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 8/13/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "MediaContent.h"
#import <AVFoundation/AVFoundation.h>

typedef void(^ProgressCallback)(CGFloat progress);
typedef void(^CompletionCallback)(BOOL completed);

@interface LocalMediaContent : MediaContent <AVAssetResourceLoaderDelegate>

@property(assign, nonatomic)int shardSize;
@property(copy, nonatomic)ProgressCallback progressBlock;
@property(copy, nonatomic)CompletionCallback completionBlock;
@property(strong, nonatomic)NSMutableDictionary* shards;

-(BOOL)isDownloaded;
-(long)currentLocalFileLength;
-(void) downloadWithProgressBlock:(void(^)(CGFloat progress))progressBlock
                  completionBlock:(void(^)(BOOL completed))completionBlock ;
-(NSString*)getFileName;
-(NSString*)getDirName;
-(NSString*)getFileExtension;
-(void)createDirs;

-(NSString*)localFilePath;
-(BOOL)localFileExists;
-(NSURL*)playUrl;
-(CMTime)duration;

-(BOOL) isDownloadingProgressBlock:(void(^)(CGFloat progress))progressBlock
                   completionBlock:(void(^)(BOOL completed))completionBlock;

-(BOOL)isSingleShard;
-(int)numOfShards;
@end
