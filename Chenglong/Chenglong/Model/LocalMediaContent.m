//
//  LocalMediaContent.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 8/13/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "LocalMediaContent.h"
#import "TWRDownloadManager.h"


@implementation LocalMediaContent

-(id)init
{
    self = [super init];
    self.shardSize = 64*1024*4;
    self.shards = [NSMutableDictionary new];
    self.progressBlock = nil;
    self.completionBlock = nil;
    return self;
}

-(NSURL*)playUrl {
    if([self isDownloaded]) {
        return [NSURL fileURLWithPath:[self localFilePath]];
    }
    else {
        NSString* token = [Lockbox stringForKey:kOauthTokenKey];
        token = [token substringFromIndex:7];
        NSString* url = NULL;
        if([self.url containsString:@"?"])
            url = [NSString stringWithFormat:@"%@&access_token=%@", self.url, token];
        else
            url = [NSString stringWithFormat:@"%@?access_token=%@", self.url, token];
        return [NSURL URLWithString:url];
    }
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
    for(int i=0; i<self.numOfShards; i++) {
        LocalMediaContentShard* shard = [self getShard:i];
        if(![shard isDownloaded])
            return NO;
    }
    return YES;
}

-(long)currentLocalFileLength
{
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSString* filePath = self.localFilePath;
    if(![filemgr fileExistsAtPath:filePath isDirectory:nil]) {
        return 0;
    }
    unsigned long long fileSize = [[filemgr attributesOfItemAtPath:filePath error:nil] fileSize];
    return fileSize;
}

-(BOOL) isDownloadingProgressBlock:(void(^)(CGFloat progress))progressBlock
                   completionBlock:(void(^)(BOOL completed))completionBlock
{
    for(int i=0; i<self.numOfShards; i++) {
        LocalMediaContentShard* shard = [self getShard:i];
        if([[TWRDownloadManager sharedManager] isFileDownloadingForLocalMediaContentShard:shard withProgressBlock:^(LocalMediaContentShard* shard, CGFloat progress) {
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
        
        BOOL downloading = [[TWRDownloadManager sharedManager] isFileDownloadingForLocalMediaContentShard:shard withProgressBlock:^(LocalMediaContentShard* shard, CGFloat progress) {
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
        [shard deleteFile];
        [[TWRDownloadManager sharedManager] downloadFileForLocalMediaContentShard:shard progressBlock:^(LocalMediaContentShard *shard, CGFloat progress) {
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

- (BOOL) resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest
{
    AVAssetResourceLoadingDataRequest* dataRequest = loadingRequest.dataRequest;
    AVAssetResourceLoadingContentInformationRequest* contentRequest = loadingRequest.contentInformationRequest;
    
    NSLog(@"requesting data %lld %ld", dataRequest.requestedOffset, dataRequest.requestedLength);
    
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
        NSData* data = [NSData dataWithContentsOfFile:shard.localFilePath];
        long shardStartOffset = shardIndex * self.shardSize;
        long offsetInData = offset - shardStartOffset;
        long length = data.length - offsetInData;
        if(length > dataRequest.requestedLength)
            length = dataRequest.requestedLength;
        
        NSData *dataAvailable = [data subdataWithRange:NSMakeRange(offsetInData, length)];
        [dataRequest respondWithData:dataAvailable];
        [loadingRequest finishLoading];
    }
    
    return YES;
}

-(void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest
{
    NSLog(@"didCancelLoadingRequest");
}

-(void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)authenticationChallenge {
    NSLog(@"didCancelAuthenticationChallenge");
}
@end
