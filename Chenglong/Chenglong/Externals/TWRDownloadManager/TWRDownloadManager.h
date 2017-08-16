//
//  TWRDownloadManager.h
//  DownloadManager
//
//  Created by Michelangelo Chasseur on 25/07/14.
//  Copyright (c) 2014 Touchware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalMediaContentShard.h"

@interface TWRDownloadManager : NSObject

@property (nonatomic, strong) void(^backgroundTransferCompletionHandler)();

+ (instancetype)sharedManager;

- (BOOL)isFileDownloadingForLocalMediaContentShard:(LocalMediaContentShard*)mediaContent
                       withProgressBlock:(void(^)(LocalMediaContentShard* shard, CGFloat progress))block
                         completionBlock:(void(^)(LocalMediaContentShard* shard, BOOL completed))completionBlock;

- (BOOL)isFileDownloadingForLocalMediaContentShard:(LocalMediaContentShard*) mediaContent;

- (void)cancelAllDownloads;

/**
 *  This method helps checking which downloads are currently ongoing.
 *
 *  @return an NSArray of NSString with the URLs of the currently downloading files.
 */
- (NSArray *)currentDownloads;

- (int)currentNumOfDownloads;

- (void)downloadFileForObject:(id)obj
                      withURL:(NSString *)urlString
                     withName:(NSString *)fileName
             inDirectoryNamed:(NSString *)directory
                progressBlock:(void(^)(LocalMediaContentShard* shard, CGFloat progress))progressBlock
              completionBlock:(void(^)(LocalMediaContentShard* shard, BOOL completed))completionBlock
         enableBackgroundMode:(BOOL)backgroundMode;
@end
