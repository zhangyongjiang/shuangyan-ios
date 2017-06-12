//
//  LocalMediaContent.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/10/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "LocalMediaContent.h"
#import "TWRDownloadManager.h"

@implementation LocalMediaContent

-(BOOL)isDownloaded {
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSString* filePath = self.filePath;
    if(![filemgr fileExistsAtPath:filePath isDirectory:nil]) {
        return NO;
    }
    unsigned long long fileSize = [[filemgr attributesOfItemAtPath:filePath error:nil] fileSize];
    if(fileSize != [self.mediaContent.length longLongValue]) {
        return NO;
    }
    return YES;
}

-(void) downloadWithProgressBlock:(void(^)(CGFloat progress))progressBlock
                  completionBlock:(void(^)(BOOL completed))completionBlock {
    NSString* currdir = [[NSFileManager defaultManager] currentDirectoryPath];
    NSString* fileName = [self.filePath lastPathComponent];
    NSString* dirName = [self.filePath substringToIndex:(self.filePath.length - fileName.length)];
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:dirName];
    NSLog(@"%@\n\n%@\n\n%@\n\n%d", currdir, fileName, dirName, exist);
    [[TWRDownloadManager sharedManager] downloadFileForURL:self.mediaContent.url withName:fileName inDirectoryNamed:dirName progressBlock:^(CGFloat progress) {
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
@end
