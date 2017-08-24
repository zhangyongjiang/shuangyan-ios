//
//  LocalMediaContent.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 8/13/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "LocalMediaContent.h"
#import "TWRDownloadManager.h"
#import "LocalMediaContentShardGroup.h"

@interface LocalMediaContent()
{
    BOOL downloadCancelled;
}

@end

@implementation LocalMediaContent

-(id)init
{
    self = [super init];
    self.shardSize = 65536*4; // big number will cause UI freeze
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
    int i=0;
    for(; i<self.numOfShards; i++) {
        LocalMediaContentShard* shard = [self getShard:i];
        if(![shard isDownloaded]) {
            break;
        }
    }
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
            CGFloat downloaded = shard.shard*self.shardSize-progress;
            progress = downloaded / self.length.floatValue;
            self.progressBlock(progress);
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

-(LocalMediaContentShardGroup*)downloadWithProgressBlock:(void (^)(CGFloat))progressBlock completionBlock:(void (^)(BOOL))completionBlock forShards:(int)shard, ...
{
    NSMutableArray<LocalMediaContentShard*>* shards = [NSMutableArray new];
    va_list args;   va_start(args, shard);
    for (int arg = shard;  arg != -1; arg = va_arg( args, int)) {
        [shards addObject:[self getShard:arg]];
    }
    va_end(args);
    
    LocalMediaContentShardGroup* group = [[LocalMediaContentShardGroup alloc] initWithShards:shards];
    [group downloadWithCompletionBlock:completionBlock];
    return group;
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

-(NSData*)downloadNowForDataAtOffset:(long)offset length:(long)length
{
    long startShardIndex = offset / self.shardSize;
    long endShardIndex = (offset + length) / self.shardSize;
    if(endShardIndex - startShardIndex > 1)
        endShardIndex = startShardIndex;
    NSLog(@"downloadNowForDataAtOffset startShard %ld endShard %ld offset %ld length %ld", startShardIndex, endShardIndex, offset, length);
    for(int i=startShardIndex; i<=endShardIndex; i++) {
        LocalMediaContentShard* shard = [self getShard:i];
        if(shard.isDownloaded)
            continue;
        [shard directDownload];
//        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
//            [shard downloadWithProgressBlock:^(LocalMediaContentShard *shard, CGFloat progress) {
//            } completionBlock:^(LocalMediaContentShard *shard, BOOL completed) {
//                NSLog(@"shard %d download completed %i", shard.shard, completed);
//                dispatch_semaphore_signal(sema);
//            } enableBackgroundMode:YES];
//        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    NSMutableData* data = [NSMutableData new];
    for(int i=startShardIndex; i<=endShardIndex; i++) {
        LocalMediaContentShard* shard = [self getShard:i];
        if(!shard.isDownloaded) {
            break;
        }
        [data appendData:shard.data];
    }
    if((data.length-(offset-startShardIndex*self.shardSize))<length)
        length = data.length-(offset-startShardIndex*self.shardSize);
    return [data subdataWithRange:NSMakeRange(offset-startShardIndex*self.shardSize, length)];
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
        NSData* data = [self downloadNowForDataAtOffset:dataRequest.requestedOffset length:dataRequest.requestedLength];
        if(data) {
            [dataRequest respondWithData:data];
        } else {
            NSLog(@"no data served");
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
    NSURL *sourceMovieURL = [NSURL fileURLWithPath:self.localFilePath];
    AVURLAsset *sourceAsset = [AVURLAsset URLAssetWithURL:sourceMovieURL options:nil];
    CMTime duration = sourceAsset.duration;
    return duration;
}

+(UIImage *)getPlaceholderImageFromVideo:(NSURL *)url {
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    CMTime time = [asset duration];
    time.value = 0;
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return thumbnail;
}

-(void)getPlaceholderImageForVideo:(void(^)(UIImage* image))completionBlock {
    NSURL *url = [NSURL fileURLWithPath:self.localFilePath];
    UIImage *thumbnail = [LocalMediaContent getPlaceholderImageFromVideo:url];
//    if(thumbnail == NULL) {
//        url = [NSURL URLWithString:self.urlWithToken];
//        thumbnail = [LocalMediaContent getPlaceholderImageFromVideo:url];
//    }
//    else {
        completionBlock(thumbnail);
//    }
}

-(NSString*)urlWithToken {
    NSString* url = self.url;
    if(![url containsString:@"aliyuncs.com"])
        url = [NSString stringWithFormat:@"%@&access_token=%@", url, AppDelegate.userAccessToken];
    return url;
}
@end
