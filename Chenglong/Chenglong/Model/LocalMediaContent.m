//
//  LocalMediaContent.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 8/13/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "LocalMediaContent.h"
#import "TWRDownloadManager.h"

@interface LocalMediaContent()
{
    BOOL downloadCancelled;
}

@end

@implementation LocalMediaContent

-(id)init
{
    self = [super init];
//    self.shardSize = 1048576;
    self.shardSize = 524288;
    self.shards = [NSMutableDictionary new];
    self.progressBlock = nil;
    self.completionBlock = nil;
    downloadCancelled = NO;
    return self;
}

-(LocalMediaContentShard*)getShard:(int)shard
{
    NSNumber* num = [NSNumber numberWithInt:shard];
    LocalMediaContentShard* value = [self.shards objectForKey:num];
    if(value == NULL) {
        value = [[LocalMediaContentShard alloc] initWithLocalMediaContent:self andShard:shard];
        [self.shards setObject:value forKey:num];
    }
    return value;
}

-(BOOL)isDownloaded {
    NSString* parentFilePath = self.localFilePath;
    File* f = [[File alloc] initWithFullPath:parentFilePath];
    NSFileHandle* fhandler;
    long currentLength = 0;
    fhandler = [NSFileHandle fileHandleForWritingAtPath:self.localFilePath];
    if(f.exists) {
        if(f.length==self.length.longLongValue)
            return YES;
        currentLength = (f.length / self.shardSize) * self.shardSize;
        [fhandler seekToFileOffset:currentLength];
    } else {
        [self createDirs];
    }

    int i=0;
    for(; i<self.numOfShards; i++) {
        LocalMediaContentShard* shard = [self getShard:i];
        if(![shard isDownloaded]) {
            break;
        }
        if(shard.offset == currentLength) {
            [fhandler writeData:shard.data];
            currentLength += shard.expectedDownloadSize;
        }
    }
    [fhandler closeFile];
    return i==self.numOfShards;
}

-(long)currentLocalFileLength
{
    long total = 0;
    for(int i=0; i<self.numOfShards; i++) {
        LocalMediaContentShard* shard = [self getShard:i];
        if(shard.isDownloaded)
            total += shard.expectedDownloadSize;
        else
            break;
    }
    return total;
}

-(BOOL) isDownloadingProgressBlock:(void(^)(CGFloat progress))progressBlock
                   completionBlock:(void(^)(BOOL completed))completionBlock
{
    for(int i=0; i<self.numOfShards; i++) {
        LocalMediaContentShard* shard = [self getShard:i];
        if([[TWRDownloadManager sharedManager] isFileDownloadingForObject:shard
                                                                  withUrl:shard.url
                                                        withProgressBlock:^(LocalMediaContentShard* shard, CGFloat progress) {
            [shard.localMediaContent downloadProgress:progress forShard:shard];
        } completionBlock:^(LocalMediaContentShard* shard, BOOL completed) {
            [shard.localMediaContent downloadCompleted:completed forShard:shard];
        }]) {
            self.progressBlock = progressBlock;
            self.completionBlock = completionBlock;
            return YES;
        }
    }
    return NO;
}

-(void)downloadProgress:(CGFloat)progress forShard:(LocalMediaContentShard*)shard
{
    if(progress<0) {
        if(self.progressBlock != NULL) {
            self.progressBlock(-shard.shard*self.shardSize+progress);
        }
    }
    else {
        if(self.progressBlock != NULL) {
            self.progressBlock((progress*shard.expectedDownloadSize+shard.shard*self.shardSize)/self.length.intValue);
        }
    }
}

-(void)downloadCompleted:(BOOL)completed forShard:(LocalMediaContentShard*)shard
{
    NSLog(@"shard %d completed %d", shard.shard, completed);
    if(!completed) {
        if(self.completionBlock != NULL)
            self.completionBlock(completed);
        return;
    }
    
    if(shard.shard == (self.numOfShards-1)) {
        if(self.completionBlock != NULL)
            self.completionBlock(completed);
    }
    else {
        [self downloadWithProgressBlock:self.progressBlock completionBlock:self.completionBlock];
    }
}

-(void)deleteLocalFile
{
    NSFileManager *filemgr = [NSFileManager defaultManager];
    [filemgr removeItemAtPath:self.localFilePath error:nil];
    
    for(int i=0; i<self.numOfShards; i++) {
        LocalMediaContentShard* shard = [self getShard:i];
        [shard deleteFile];
    }
}

-(void) downloadShard:(int)shardIndex WithProgressBlock:(void(^)(CGFloat progress))progressBlock
                  completionBlock:(void(^)(BOOL completed))completionBlock {
    LocalMediaContentShard* shard = [self getShard:shardIndex];
    if(shard.isDownloaded) {
        if(completionBlock)
            completionBlock(YES);
        return;
    }

    BOOL downloading = [[TWRDownloadManager sharedManager] isFileDownloadingForObject:shard withUrl:shard.url withProgressBlock:^(LocalMediaContentShard* shard, CGFloat progress) {
        progressBlock(progress);
    } completionBlock:^(LocalMediaContentShard* shard, BOOL completed) {
        completionBlock(completed);
    }];
    if(downloading) {
        return;
    }

    [self createDirs];
    [shard downloadWithProgressBlock:^(LocalMediaContentShard *shard, CGFloat progress) {
        progressBlock(progress);
    } completionBlock:^(LocalMediaContentShard *shard, BOOL completed) {
        completionBlock(completed);
    } enableBackgroundMode:YES];
}

-(void) downloadWithProgressBlock:(void(^)(CGFloat progress))progressBlock
                  completionBlock:(void(^)(BOOL completed))completionBlock {
    if([self isDownloaded]) {
        if(completionBlock)
            completionBlock(YES);
        return;
    }
    
    [self createDirs];

    int i=0;
    for(; i<self.numOfShards; i++) {
        LocalMediaContentShard* shard = [self getShard:i];
        if(shard.isDownloaded)
            continue;
        
        BOOL downloading = [[TWRDownloadManager sharedManager] isFileDownloadingForObject:shard withUrl:shard.url withProgressBlock:^(LocalMediaContentShard* shard, CGFloat progress) {
            [shard.localMediaContent downloadProgress:progress forShard:shard];
        } completionBlock:^(LocalMediaContentShard* shard, BOOL completed) {
            [shard.localMediaContent downloadCompleted:completed forShard:shard];
        }];
        if(downloading) {
            NSLog(@"download ongoing for shard %d and url %@", i, shard.url);
            self.progressBlock = progressBlock;
            self.completionBlock = completionBlock;
            return;
        }
        
        NSLog(@"start download for shard %d and url %@", i, shard.url);
        self.progressBlock = progressBlock;
        self.completionBlock = completionBlock;
        [shard downloadWithProgressBlock:^(LocalMediaContentShard *shard, CGFloat progress) {
            [shard.localMediaContent downloadProgress:progress forShard:shard];
        } completionBlock:^(LocalMediaContentShard *shard, BOOL completed) {
            [shard.localMediaContent downloadCompleted:completed forShard:shard];
        } enableBackgroundMode:YES];
        break;
    }
}

-(NSString*)getFileName {
    return [self.localFilePath lastPathComponent];
}

-(NSString*)getDirName {
    return [self.localFilePath substringToIndex:(self.localFilePath.length - [self getFileName].length)];
}

-(void)createDirs {
    NSFileManager* fm = [NSFileManager defaultManager];
    if([fm fileExistsAtPath:[self getDirName]])
        return;
    [fm createDirectoryAtPath:[self getDirName] withIntermediateDirectories:YES attributes:nil error:nil];
}

-(NSString*)getFileExtension {
    NSString* originName = self.name;
    if(originName == nil)
        return nil;
    
    NSString* ext = [originName substringFromIndex:([originName indexOf:@"."]+1)];
    return ext;
}

-(NSString*)localFilePath {
    return [NSString stringWithFormat:@"%@/%@", [File mediaHomeDir], self.path];
}

-(NSString*)localMetaFilePath {
    return [NSString stringWithFormat:@"%@.json", self.localFilePath];
}
-(void)saveMeta {
    NSString* json = [self toJson];
    [json writeToFile:[self localMetaFilePath] atomically:YES encoding:NSUTF8StringEncoding error:nil];
}
+(LocalMediaContent*)loadMediaContent {
//    File* file = [[File alloc] initWithFullPath:[self jsonFileName]];
//    if([file exists] && [[file lastModifiedTime] timeIntervalSinceNow]<3600){
//        NSData* data = file.content;
//        if(!data) {
//            [self refreshPage];
//        }
//        else {
//            NSError *error;
//            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
//                                                                 options:kNilOptions
//                                                                   error:&error];
//            ObjectMapper* mapper = [ObjectMapper mapper];
//            CourseDetailsList* resp = [mapper mapObject:json toClass:[CourseDetailsList class] withError:&error];
//            if(error)
//                [self refreshPage];
//            else {
//                self.navigationItem.title = resp.courseDetails.course.title;
//                [self displayData:resp];
//            }
//        }
//    }
    return NULL;
}

-(BOOL)localFileExists
{
    NSFileManager* fm = [NSFileManager defaultManager];
    BOOL isDirectory;
    return [fm fileExistsAtPath:[self localFilePath] isDirectory:&isDirectory];
}

-(int)shardSize
{
    if(_shardSize == 0) {
        _shardSize = self.length.intValue;
    }
    if(_shardSize == 0) {
        NSLog(@"wrong shard size");
    }
    return _shardSize;
}

-(int)numOfShards
{
    if(self.length.integerValue % self.shardSize == 0)
        return self.length.integerValue / self.shardSize;
    else
        return self.length.integerValue / self.shardSize + 1;
}

-(BOOL)isSingleShard
{
    return self.numOfShards == 1;
}

-(BOOL) resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForResponseToAuthenticationChallenge:(NSURLAuthenticationChallenge *)authenticationChallenge
{
    NSLog(@"shouldWaitForResponseToAuthenticationChallenge");
    return NO;
}

-(BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForRenewalOfRequestedResource:(AVAssetResourceRenewalRequest *)renewalRequest
{
    NSLog(@"shouldWaitForRenewalOfRequestedResource");
    return NO;
}

-(NSData*)getDataFromOffset:(long)offset withLength:(long)requestedLength
{
    NSMutableData* data = [NSMutableData dataWithCapacity:requestedLength];
    while(requestedLength > 0) {
        int shardIndex = offset / self.shardSize;
        LocalMediaContentShard* shard = [self getShard:shardIndex];
        if(!shard.isDownloaded)
            break;
        NSData* shardData = [shard data];
        
        long offsetInData = offset - shardIndex * self.shardSize;
        long length = shardData.length - offsetInData;
        if(length > requestedLength)
            length = requestedLength;
        
        NSData *dataAvailable = [shardData subdataWithRange:NSMakeRange(offsetInData, length)];
        [data appendData:dataAvailable];
        requestedLength -= length;
        offset += length;
    }
    return data;
}

- (BOOL) resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest
{
    AVAssetResourceLoadingDataRequest* dataRequest = loadingRequest.dataRequest;
    AVAssetResourceLoadingContentInformationRequest* contentRequest = loadingRequest.contentInformationRequest;
    
//    NSLog(@"requesting  %ld bytes at offset %lld/%lld  ", dataRequest.requestedLength, dataRequest.requestedOffset, self.length.longLongValue);
    
    //handle content request
    if (contentRequest)
    {
        NSString *mimeType = self.contentType;
        CFStringRef contentType = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef)(mimeType), NULL);
        contentRequest.contentType = CFBridgingRelease(contentType);
        contentRequest.contentLength = self.length.longLongValue;
        contentRequest.byteRangeAccessSupported = YES;
    }
    
    //handle data request
    if (dataRequest)
    {
        long long offset = dataRequest.requestedOffset;
        int shardIndex = offset / self.shardSize;
        LocalMediaContentShard* shard = [self getShard:shardIndex];
        if(!shard.isDownloaded) {
            if(!shard.isDownloading) {
                NSLog(@"start downloading shard %d ", shardIndex);
                [self createDirs];
                [shard downloadWithProgressBlock:^(LocalMediaContentShard *shard, CGFloat progress) {
//                    NSLog(@"downloading shard %d with progress %f", shard.shard, progress);
                } completionBlock:^(LocalMediaContentShard *shard, BOOL completed) {
                    NSLog(@"finished downloading shard %d ", shard.shard);
                } enableBackgroundMode:YES];
            }
        }
        else {
//            NSLog(@"shard %d is available", shardIndex);
            NSData* data = [self getDataFromOffset:offset withLength:dataRequest.requestedLength];
            [dataRequest respondWithData:data];
            
            for(shardIndex++;shardIndex < self.numOfShards;shardIndex++) {
                LocalMediaContentShard* nextShard = [self getShard:shardIndex];
                if(nextShard.isDownloaded) {
                    NSLog(@" shard %d downloaded already", shardIndex);
                    continue;
                }
                if(!nextShard.isDownloading) {
                    if([TWRDownloadManager sharedManager].currentNumOfDownloads>1)
                        break;
                    NSLog(@"start downloading shard %d ", shardIndex);
                    [nextShard downloadWithProgressBlock:^(LocalMediaContentShard *shard, CGFloat progress) {
//                        NSLog(@"downloading shard %d with progress %f", shard.shard, progress);
                    } completionBlock:^(LocalMediaContentShard *shard, BOOL completed) {
                        NSLog(@"finished downloading shard %d ", shard.shard);
                    } enableBackgroundMode:YES];
                    break;
                }
            }
        }
        [loadingRequest finishLoading];
    }
    return YES;
}

-(void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest
{
    NSLog(@"didCancelLoadingRequest");
    downloadCancelled = YES;
}

-(void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)authenticationChallenge {
    NSLog(@"didCancelAuthenticationChallenge");
}

-(CMTime)duration
{
    LocalMediaContentShard* shard0 = [self getShard:0];
    return shard0.duration;
}
@end
