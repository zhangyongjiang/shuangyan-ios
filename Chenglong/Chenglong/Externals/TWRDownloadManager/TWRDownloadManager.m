//
//  TWRDownloadManager.m
//  DownloadManager
//
//  Created by Michelangelo Chasseur on 25/07/14.
//  Copyright (c) 2014 Touchware. All rights reserved.
//

#import "TWRDownloadManager.h"

@interface TWRDownloadManager () <NSURLSessionDelegate, NSURLSessionDownloadDelegate>

@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSURLSession *backgroundSession;
@property (strong, nonatomic) NSMutableDictionary *downloads;
@property (SDDispatchQueueSetterSementics, nonatomic) dispatch_queue_t downloadQueue;

@end

@implementation TWRDownloadManager

+ (instancetype)sharedManager {
    static TWRDownloadManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[TWRDownloadManager alloc] init];
    });
    
    return _sharedManager;
}

+(dispatch_queue_t)queue {
    return [TWRDownloadManager sharedManager].downloadQueue;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // Default session
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.HTTPCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage;
        configuration.HTTPShouldSetCookies = YES;
        self.session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        
        // Background session
        NSURLSessionConfiguration *backgroundConfiguration = [NSURLSessionConfiguration backgroundSessionConfiguration:@"re.touchwa.downloadmanager"];
        
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
            backgroundConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"re.touchwa.downloadmanager"];
        }
        
        self.backgroundSession = [NSURLSession sessionWithConfiguration:backgroundConfiguration delegate:self delegateQueue:nil];
        
        self.downloads = [NSMutableDictionary new];
        self.downloadQueue = dispatch_queue_create("com.babazaojiao.downloader", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

#pragma mark - Downloading... 

+(NSDictionary<NSString *, NSString *> *)queryParametersFromURL:(NSString *)url {
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:url];
    NSMutableDictionary<NSString *, NSString *> *queryParams = [NSMutableDictionary<NSString *, NSString *> new];
    for (NSURLQueryItem *queryItem in [urlComponents queryItems]) {
        if (queryItem.value == nil) {
            continue;
        }
        [queryParams setObject:queryItem.value forKey:queryItem.name];
    }
    return queryParams;
}

- (BOOL)downloadFileForURL:(NSString *)urlString
             progressBlock:(void(^)(LocalMediaContentShard* shard, CGFloat progress))progressBlock
             remainingTime:(void(^)(LocalMediaContentShard* shard, NSUInteger seconds))remainingTimeBlock
           completionBlock:(void(^)(LocalMediaContentShard* shard, BOOL completed))completionBlock
      enableBackgroundMode:(BOOL)backgroundMode {
    NSURL *url = [NSURL URLWithString:urlString];
    NSDictionary* dict = [TWRDownloadManager queryParametersFromURL:urlString];
    NSString* soffset = [dict objectForKey:@"offset"];
    NSString* slength = [dict objectForKey:@"length"];
    NSString* range = [NSString stringWithFormat:@"bytes=%@-%d", soffset, (soffset.intValue + slength.intValue-1)];
    
    if (![self fileDownloadCompletedForUrl:urlString]) {
        NSLog(@"File is downloading!");
        return NO;
    }
    
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSString* token = [Lockbox stringForKey:kOauthTokenKey];
        [request setValue:token forHTTPHeaderField:@"Authorization"];
        [request setValue:range forHTTPHeaderField:@"Range"];
        
        NSURLSessionDownloadTask *downloadTask;
    WeakSelf(weakSelf)
        if (backgroundMode) {
            downloadTask = [self.backgroundSession downloadTaskWithRequest:request /*completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                TWRDownloadObject *download = [weakSelf.downloads objectForKey:urlString];
                NSHTTPURLResponse *urlresp = response;
                 NSInteger statusCode = [urlresp statusCode];
                if (statusCode != 200) {
                    NSLog(@"download error status code %ld for url %@", (long)statusCode, urlString);
                    download.completionBlock(download.delegate, NO);
                }
            }*/];
        } else {
            downloadTask = [self.session downloadTaskWithRequest:request];
        }
        TWRDownloadObject *downloadObject = [[TWRDownloadObject alloc] initWithDownloadTask:downloadTask progressBlock:progressBlock remainingTime:remainingTimeBlock completionBlock:completionBlock];
        downloadObject.startDate = [NSDate date];
        [self.downloads addEntriesFromDictionary:@{urlString:downloadObject}];
        [downloadTask resume];
        return YES;
}

- (void)downloadFileForObject:(id<DownloaderDelegate>)obj
                    withURL:(NSString *)urlString
             progressBlock:(void(^)(id shard, CGFloat progress))progressBlock
           completionBlock:(void(^)(id shard, BOOL completed))completionBlock
      enableBackgroundMode:(BOOL)backgroundMode {
    [self downloadFileForURL:urlString
              progressBlock:progressBlock
              remainingTime:nil
            completionBlock:completionBlock
        enableBackgroundMode:backgroundMode];
    TWRDownloadObject *download = [self.downloads objectForKey:urlString];
    if (download) {
        download.delegate = obj;
    }
    else {
        NSLog(@"wrong-------------------------");
    }
}

- (void)cancelDownloadForUrl:(NSString *)fileIdentifier {
    TWRDownloadObject *download = [self.downloads objectForKey:fileIdentifier];
    if (download) {
        [download.downloadTask cancel];
        [self.downloads removeObjectForKey:fileIdentifier];
        if (download.completionBlock) {
            download.completionBlock(download.delegate, NO);
        }
    }
    if (self.downloads.count == 0) {
//        [self cleanTmpDirectory];
//        
    }
}

- (void)cancelAllDownloads {
    [self.downloads enumerateKeysAndObjectsUsingBlock:^(id key, TWRDownloadObject *download, BOOL *stop) {
        if (download.completionBlock) {
            download.completionBlock(download.delegate, NO);
        }
        [download.downloadTask cancel];
        [self.downloads removeObjectForKey:key];
    }];
//    [self cleanTmpDirectory];
}

-(int)currentNumOfDownloads
{
    return self.downloads.count;
}

- (NSArray *)currentDownloads {
    NSMutableArray *currentDownloads = [NSMutableArray new];
    [self.downloads enumerateKeysAndObjectsUsingBlock:^(id key, TWRDownloadObject *download, BOOL *stop) {
        [currentDownloads addObject:download.downloadTask.originalRequest.URL.absoluteString];
    }];
    return currentDownloads;
}

#pragma mark - NSURLSession Delegate

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    NSString *fileIdentifier = downloadTask.originalRequest.URL.absoluteString;
    TWRDownloadObject *download = [self.downloads objectForKey:fileIdentifier];
    if(!download) {
        NSLog(@"nil download object for url %@", fileIdentifier);
    }
    if (download.progressBlock) {
        CGFloat progress = (CGFloat)totalBytesWritten / (CGFloat)totalBytesExpectedToWrite;
            download.progressBlock(download.delegate, progress);
    }
    
    CGFloat remainingTime = [self remainingTimeForDownload:download bytesTransferred:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
    if (download.remainingTimeBlock) {
            download.remainingTimeBlock(download.delegate, (NSUInteger)remainingTime);
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
//    NSLog(@"Download finisehd!");
    
    NSError *error;
    NSURL *destinationLocation;
    
    NSString *fileIdentifier = downloadTask.originalRequest.URL.absoluteString;
    TWRDownloadObject *download = [self.downloads objectForKey:fileIdentifier];
    if(!download) {
        NSLog(@"download is nil for url %@", location);
        return;
    }
    
    BOOL copied = [download.delegate copyDownloadedFile:location withObject:download.delegate];
    
    if (download.completionBlock) {
        download.completionBlock(download.delegate, copied);
    }
    
    // remove object from the download
    [self.downloads removeObjectForKey:fileIdentifier];
}

- (CGFloat)remainingTimeForDownload:(TWRDownloadObject *)download
                   bytesTransferred:(int64_t)bytesTransferred
          totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:download.startDate];
    CGFloat speed = (CGFloat)bytesTransferred / (CGFloat)timeInterval;
    CGFloat remainingBytes = totalBytesExpectedToWrite - bytesTransferred;
    CGFloat remainingTime =  remainingBytes / speed;
    return remainingTime;
}

#pragma mark - File Management

- (BOOL)fileDownloadCompletedForUrl:(NSString *)fileIdentifier {
    BOOL retValue = YES;
    TWRDownloadObject *download = [self.downloads objectForKey:fileIdentifier];
    if (download) {
        // downloads are removed once they finish
        retValue = NO;
    }
    return retValue;
}

- (BOOL)isFileDownloadingForUrl:(NSString *)fileIdentifier
              withProgressBlock:(void(^)(LocalMediaContentShard* shard, CGFloat progress))block {
    return [self isFileDownloadingForUrl:fileIdentifier
                       withProgressBlock:block
                         completionBlock:nil];
}

- (BOOL)isFileDownloadingForUrl:(NSString*)url {
    TWRDownloadObject *download = [self.downloads objectForKey:url];
    return download != NULL;
}

- (BOOL)isFileDownloadingForObject:(id)object
                           withUrl:(NSString*)url
                 withProgressBlock:(void(^)(id object, CGFloat progress))block
                completionBlock:(void(^)(id object, BOOL completed))completionBlock {
    return [self isFileDownloadingForUrl:url withProgressBlock:block completionBlock:completionBlock];
}

- (BOOL)isFileDownloadingForUrl:(NSString *)fileIdentifier
              withProgressBlock:(void(^)(LocalMediaContentShard* shard, CGFloat progress))block
                completionBlock:(void(^)(LocalMediaContentShard* shard, BOOL completed))completionBlock {
    BOOL retValue = NO;
    TWRDownloadObject *download = [self.downloads objectForKey:fileIdentifier];
    if (download) {
        download.progressBlock = block;
        download.completionBlock = completionBlock;
        retValue = YES;
    }
    return retValue;
}

#pragma mark File existance

- (NSString *)localPathForFile:(NSString *)fileIdentifier {
    return [self localPathForFile:fileIdentifier inDirectory:nil];
}

- (NSString *)localPathForFile:(NSString *)fileIdentifier inDirectory:(NSString *)directoryName {
    NSString *fileName = [fileIdentifier lastPathComponent];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    return [[cachesDirectory stringByAppendingPathComponent:directoryName] stringByAppendingPathComponent:fileName];
}

- (BOOL)fileExistsForUrl:(NSString *)urlString {
    return [self fileExistsForUrl:urlString inDirectory:nil];
}

- (BOOL)fileExistsForUrl:(NSString *)urlString inDirectory:(NSString *)directoryName {
    return [self fileExistsWithName:[urlString lastPathComponent] inDirectory:directoryName];
}

- (BOOL)fileExistsWithName:(NSString *)fileName
               inDirectory:(NSString *)directoryName {
    BOOL exists = NO;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    
    // if no directory was provided, we look by default in the base cached dir
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[cachesDirectory stringByAppendingPathComponent:directoryName] stringByAppendingPathComponent:fileName]]) {
        exists = YES;
    }
    
    return exists;
}

- (BOOL)fileExistsWithName:(NSString *)fileName {
    return [self fileExistsWithName:fileName inDirectory:nil];
}

#pragma mark - Background download

-(void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    // Check if all download tasks have been finished.
    [session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        if ([downloadTasks count] == 0) {
            if (self.backgroundTransferCompletionHandler != nil) {
                // Copy locally the completion handler.
                void(^completionHandler)() = self.backgroundTransferCompletionHandler;
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    // Call the completion handler to tell the system that there are no other background transfers.
                    completionHandler();
                    
                    // Show a local notification when all downloads are over.
                    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                    localNotification.alertBody = @"All files have been downloaded!";
                    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
                }];
                
                // Make nil the backgroundTransferCompletionHandler.
                self.backgroundTransferCompletionHandler = nil;
            }
        }
    }];
}

@end
