//
//  TWRDownloadManager.h
//  DownloadManager
//
//  Created by Michelangelo Chasseur on 25/07/14.
//  Copyright (c) 2014 Touchware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWRDownloadObject.h"


@interface TWRDownloadManager : NSObject

@property (nonatomic, strong) void(^backgroundTransferCompletionHandler)();

+ (instancetype)sharedManager;

- (BOOL)isFileDownloadingForObject:(id<DownloaderDelegate>)object
                           withUrl:(NSString*)url
                       withProgressBlock:(void(^)(id object, CGFloat progress))block
                         completionBlock:(void(^)(id object, BOOL completed))completionBlock;

- (BOOL)isFileDownloadingForUrl:(NSString*)url;

- (void)cancelAllDownloads;

/**
 *  This method helps checking which downloads are currently ongoing.
 *
 *  @return an NSArray of NSString with the URLs of the currently downloading files.
 */
- (NSArray *)currentDownloads;

- (int)currentNumOfDownloads;

- (void)downloadFileForObject:(id<DownloaderDelegate>)obj
                      withURL:(NSString *)urlString
                     withName:(NSString *)fileName
             inDirectoryNamed:(NSString *)directory
                progressBlock:(void(^)(id object, CGFloat progress))progressBlock
              completionBlock:(void(^)(id object, BOOL completed))completionBlock
         enableBackgroundMode:(BOOL)backgroundMode;
@end
