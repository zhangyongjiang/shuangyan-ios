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

-(id)initWithMediaContent:(MediaContent *)mc {
    self = [super init];
    self.mediaContent = mc;
    self.filePath = [File dirForMediaContent:mc];
    return self;
}

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
    [self createDirs];
    
    if([[TWRDownloadManager sharedManager] isFileDownloadingForUrl:self.mediaContent.url withProgressBlock:nil]) {
        [[TWRDownloadManager sharedManager] cancelDownloadForUrl:self.mediaContent.url];
    }
    
    [[TWRDownloadManager sharedManager] downloadFileForURL:self.mediaContent.url withName:[self getFileName] inDirectoryNamed:[self getDirName] progressBlock:^(CGFloat progress) {
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
    NSString* originName = self.mediaContent.name;
    if(originName == nil)
        return nil;
    
    NSString* ext = [originName substringFromIndex:([originName indexOf:@"."]+1)];
    return ext;
}

-(void)setFilePath:(NSString *)filePath {
    _filePath = filePath;
    int index = [filePath indexOf:@"."];
    if(index != -1)
        return;
    _filePath = [filePath stringByAppendingFormat:@".%@", [self getFileExtension]];
}
@end
