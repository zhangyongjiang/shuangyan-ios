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
    self.shards = [NSMutableDictionary new];
    self.progressBlock = nil;
    self.completionBlock = nil;
    return self;
}

-(NSURL*)playUrl {
    if([self isDownloaded]) {
        NSLog(@"playUrl: %@", [self localFilePath]);
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
        NSLog(@"playUrl: %@", url);
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
        
    }
}

-(void)deleteLocalFile
{
    NSFileManager *filemgr = [NSFileManager defaultManager];
    [filemgr removeItemAtPath:self.localFilePath error:nil];
}

-(void) downloadWithProgressBlock:(void(^)(CGFloat progress))progressBlock
                  completionBlock:(void(^)(BOOL completed))completionBlock {
    if([self isDownloaded]) {
        if(completionBlock)
            completionBlock(YES);
        return;
    }
    
    [self createDirs];
    NSLog(@"Download from %@ to %@", self.url, self.localFilePath);

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
            self.progressBlock = progressBlock;
            self.completionBlock = completionBlock;
            return;
        }
        
        [[TWRDownloadManager sharedManager] downloadFileForLocalMediaContentShard:shard progressBlock:^(LocalMediaContentShard *shard, CGFloat progress) {
            NSLog(@"progress %f", progress);
            [shard.localMediaContent downloadProgress:progress forShard:shard];
        } completionBlock:^(LocalMediaContentShard *shard, BOOL completed) {
            [shard.localMediaContent downloadCompleted:completed forShard:shard];
            NSLog(@"completed");
        } enableBackgroundMode:YES];
        self.progressBlock = progressBlock;
        self.completionBlock = completionBlock;
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
@end
