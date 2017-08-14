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

-(BOOL)isDownloaded {
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSString* filePath = self.localFilePath;
    if(![filemgr fileExistsAtPath:filePath isDirectory:nil]) {
        return NO;
    }
    unsigned long long fileSize = [[filemgr attributesOfItemAtPath:filePath error:nil] fileSize];
    if(fileSize != [self.length longLongValue]) {
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
    WeakSelf(weakSelf)
    for(int i=0; i<self.numOfShards; i++) {
        LocalMediaContentShard* shard = [[LocalMediaContentShard alloc] initWithLocalMediaContent:self andShard:i];
        if([[TWRDownloadManager sharedManager] isFileDownloadingForLocalMediaContentShard:shard withProgressBlock:^(LocalMediaContentShard* shard, CGFloat progress) {
            [weakSelf downloadProgress:progress forShard:shard];
        } completionBlock:^(LocalMediaContentShard* shard, BOOL completed) {
            [weakSelf downloadCompleted:completed forShard:shard];
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
        if(self.progressBlock) {
            self.progressBlock(-shard.shard*self.shardSize+progress);
        }
    }
    else {
        if(self.progressBlock) {
            self.progressBlock((progress*shard.expectedDownloadSize+shard.shard*self.shardSize)/self.length.intValue);
        }
    }
}

-(void)downloadCompleted:(BOOL)completed forShard:(LocalMediaContentShard*)shard
{
    if(!completed) {
        if(self.completionBlock)
            self.completionBlock(completed);
        return;
    }
    
    if(shard.shard == (self.numOfShards-1)) {
        if(self.completionBlock)
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

    WeakSelf(weakSelf)
    for(int i=0; i<self.numOfShards; i++) {
        LocalMediaContentShard* shard = [[LocalMediaContentShard alloc] initWithLocalMediaContent:self andShard:i];
        if(shard.isDownloaded)
            continue;
        
        if([[TWRDownloadManager sharedManager] isFileDownloadingForLocalMediaContentShard:shard withProgressBlock:^(LocalMediaContentShard* shard, CGFloat progress) {
            [weakSelf downloadProgress:progress forShard:shard];
        } completionBlock:^(LocalMediaContentShard* shard, BOOL completed) {
            [weakSelf downloadCompleted:completed forShard:shard];
        }]) {
            self.progressBlock = progressBlock;
            self.completionBlock = completionBlock;
            return;
        }
        
        [[TWRDownloadManager sharedManager] downloadFileForLocalMediaContentShard:shard progressBlock:^(LocalMediaContentShard *shard, CGFloat progress) {
            [weakSelf downloadProgress:progress forShard:shard];
        } completionBlock:^(LocalMediaContentShard *shard, BOOL completed) {
            [weakSelf downloadCompleted:completed forShard:shard];
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

-(BOOL)localFileExists
{
    NSFileManager* fm = [NSFileManager defaultManager];
    BOOL isDirectory;
    return [fm fileExistsAtPath:[self localFilePath] isDirectory:&isDirectory];
}

-(int)shardSize
{
    if(_shardSize == 0)
        return self.length;
    else
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
