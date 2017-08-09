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

-(NSString*)localFilePath {
    return [File dirForMediaContent:self];
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

-(BOOL)isDownloaded {
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSString* filePath = self.filePath;
    if(![filemgr fileExistsAtPath:filePath isDirectory:nil]) {
        return NO;
    }
    unsigned long long fileSize = [[filemgr attributesOfItemAtPath:filePath error:nil] fileSize];
    if(fileSize != [self.length longLongValue]) {
        return NO;
    }
    return YES;
}

-(void) downloadWithProgressBlock:(void(^)(CGFloat progress))progressBlock
                  completionBlock:(void(^)(BOOL completed))completionBlock {
    [self createDirs];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSString* filePath = self.filePath;
    NSLog(@"Download from %@ to %@", self.url, self.filePath);
    if([filemgr fileExistsAtPath:filePath isDirectory:nil]) {
        NSLog(@"file exists. delete first. %@ ", self.filePath);
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
    return [self.filePath lastPathComponent];
}

-(NSString*)getDirName {
    return [self.filePath substringToIndex:(self.filePath.length - [self getFileName].length)];
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

-(NSString*)filePath {
    return [File dirForMediaContent:self];
}
@end
