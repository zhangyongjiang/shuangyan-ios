//
//  TWRDownloadObject.h
//  DownloadManager
//
//  Created by Michelangelo Chasseur on 26/07/14.
//  Copyright (c) 2014 Touchware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalMediaContentShard.h"

@protocol DownloaderDelegate <NSObject>
@optional
- (BOOL)copyDownloadedFile:(NSURL*)location withObject:(id)object;
@end

typedef void(^TWRDownloadRemainingTimeBlock)(LocalMediaContentShard* shard, NSUInteger seconds);
typedef void(^TWRDownloadProgressBlock)(LocalMediaContentShard* shard, CGFloat progress);
typedef void(^TWRDownloadCompletionBlock)(LocalMediaContentShard* shard, BOOL completed);

@interface TWRDownloadObject : NSObject

@property (copy, nonatomic) TWRDownloadProgressBlock progressBlock;
@property (copy, nonatomic) TWRDownloadCompletionBlock completionBlock;
@property (copy, nonatomic) TWRDownloadRemainingTimeBlock remainingTimeBlock;

@property (strong, nonatomic) NSURLSessionDownloadTask *downloadTask;
@property (copy, nonatomic) NSDate *startDate;
@property (strong, nonatomic) id<DownloaderDelegate> delegate;

- (instancetype)initWithDownloadTask:(NSURLSessionDownloadTask *)downloadTask
                       progressBlock:(TWRDownloadProgressBlock)progressBlock
                       remainingTime:(TWRDownloadRemainingTimeBlock)remainingTimeBlock
                     completionBlock:(TWRDownloadCompletionBlock)completionBlock;

@end
