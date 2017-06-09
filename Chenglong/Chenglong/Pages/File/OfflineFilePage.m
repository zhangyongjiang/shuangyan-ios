//
//  OfflineFilePage.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/8/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "OfflineFilePage.h"
#import "TWRDownloadManager.h"

@implementation OfflineFilePage

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

-(BOOL)downloaded {
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if(![filemgr fileExistsAtPath:self.offline isDirectory:nil]) {
        NSLog(@"file doesn't exist %@", self.offline);
        return NO;
    }
    unsigned long long fileSize = [[filemgr attributesOfItemAtPath:self.offline error:nil] fileSize];
    if(fileSize != [self.online.length longLongValue]) {
        NSLog(@"remove existing file %@", self.offline);
        [filemgr removeItemAtPath:self.offline error:nil];
        return NO;
    }
    NSLog(@"file %@ exists with the same length %i", self.offline, (int)fileSize);
    return YES;
}

-(void)download {
    NSLog(@"start to download file %@ ", self.offline);
    NSString* fileName = [self.offline lastPathComponent];
    NSString* dirName = [self.offline substringToIndex:fileName.length];
    [[TWRDownloadManager sharedManager] downloadFileForURL:self.online.url withName:fileName inDirectoryNamed:dirName progressBlock:^(CGFloat progress) {
        NSLog(@"progress %f", progress);
    } completionBlock:^(BOOL completed) {
        
    } enableBackgroundMode:YES];
}

-(void) downloadWithProgressBlock:(void(^)(CGFloat progress))progressBlock
                  completionBlock:(void(^)(BOOL completed))completionBlock {
    NSString* currdir = [[NSFileManager defaultManager] currentDirectoryPath];
    NSString* fileName = [self.offline lastPathComponent];
    NSString* dirName = [self.offline substringToIndex:(self.offline.length - fileName.length)];
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:dirName];
    NSLog(@"%@\n\n%@\n\n%@\n\n%d", currdir, fileName, dirName, exist);
    [[TWRDownloadManager sharedManager] downloadFileForURL:self.online.url withName:fileName inDirectoryNamed:dirName progressBlock:^(CGFloat progress) {
        NSLog(@"progress %f", progress);
        progressBlock(progress);
    } completionBlock:^(BOOL completed) {
        completionBlock(completed);
    } enableBackgroundMode:NO];
    
}

@end
