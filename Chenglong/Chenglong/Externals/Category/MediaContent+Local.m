//
//  MediaContent+Local.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 7/11/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "MediaContent+Local.h"
#import "TWRDownloadManager.h"

@implementation MediaContent (Local)


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

-(BOOL)isDownloading
{
    return ![[TWRDownloadManager sharedManager] fileDownloadCompletedForUrl:self.url];
}

-(void) downloadWithProgressBlock:(void(^)(CGFloat progress))progressBlock
                  completionBlock:(void(^)(BOOL completed))completionBlock {
    [self createDirs];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSString* filePath = self.localFilePath;
    NSLog(@"Download from %@ to %@", self.url, self.localFilePath);
    if([filemgr fileExistsAtPath:filePath isDirectory:nil]) {
        NSLog(@"file exists. delete first. %@ ", self.localFilePath);
        [filemgr removeItemAtPath:filePath error:nil];
    }
    
    if([[TWRDownloadManager sharedManager] isFileDownloadingForUrl:self.url withProgressBlock:nil]) {
        [[TWRDownloadManager sharedManager] cancelDownloadForUrl:self.url];
    }
    
    [[TWRDownloadManager sharedManager] downloadFileForURL:self.url withName:[self getFileName] inDirectoryNamed:[self getDirName] progressBlock:^(CGFloat progress) {
        NSLog(@"progress %f", progress);
        progressBlock(progress);
    } completionBlock:^(BOOL completed) {
        completionBlock(completed);
    } enableBackgroundMode:NO];
    
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
@end
