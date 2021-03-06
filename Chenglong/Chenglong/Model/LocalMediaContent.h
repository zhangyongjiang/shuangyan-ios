//
//  LocalMediaContent.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 8/13/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "MediaContent.h"
#import "Course.h"
#import <AVFoundation/AVFoundation.h>

typedef void(^ProgressCallback)(CGFloat progress);
typedef void(^CompletionCallback)(BOOL completed);

@interface LocalMediaContent : MediaContent <AVAssetResourceLoaderDelegate>

-(int)shardSize;
-(BOOL)isDownloaded;
-(long)currentLocalFileLength;
-(void) downloadWithProgressBlock:(void(^)(CGFloat progress))progressBlock
                  completionBlock:(void(^)(BOOL completed))completionBlock ;
-(void) downloadShard:(int)shardIndex WithProgressBlock:(void(^)(CGFloat progress))progressBlock
      completionBlock:(void(^)(BOOL completed))completionBlock;
-(NSString*)getFileName;
-(NSString*)getDirName;
-(NSString*)getFileExtension;
-(void)createDirs;
-(void)deleteLocalFile;
-(NSString*)localFilePath;
-(BOOL)localFileExists;
-(CMTime)duration;
-(BOOL)isEqual:(id)object;
-(CGFloat)downloadProgress;

-(BOOL) isDownloadingProgressBlock:(void(^)(CGFloat progress))progressBlock
                   completionBlock:(void(^)(BOOL completed))completionBlock;

-(id) downloadWithProgressBlock:(void(^)(CGFloat progress))progressBlock
                  completionBlock:(void(^)(BOOL completed))completionBlock
                        forShards:(int)shard, ...;

-(BOOL)isSingleShard;
-(int)numOfShards;
-(id)getShard:(int)shard;
-(NSString*)urlWithToken;
-(UIImage *)getPlaceholderImageForVideo;

-(BOOL)isImage;
-(BOOL)isAudio;
-(BOOL)isVideo;
-(BOOL)isPdf;
-(BOOL)isText;

+(LocalMediaContent*)localMediaContentWithText:(NSString*)text;

@end
