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

-(void)download {
    NSLog(@"start to download file %@ ", self.localMediaContent.filePath);
    NSString* fileName = [self.localMediaContent.filePath lastPathComponent];
    NSString* dirName = [self.localMediaContent.filePath substringToIndex:fileName.length];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if(![filemgr fileExistsAtPath:dirName]) {
        [filemgr createDirectoryAtPath:dirName withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    [[TWRDownloadManager sharedManager] downloadFileForURL:self.localMediaContent.mediaContent.url withName:fileName inDirectoryNamed:dirName progressBlock:^(CGFloat progress) {
        NSLog(@"progress %f", progress);
    } completionBlock:^(BOOL completed) {
        
    } enableBackgroundMode:YES];
}

-(void) downloadWithProgressBlock:(void(^)(CGFloat progress))progressBlock
                  completionBlock:(void(^)(BOOL completed))completionBlock {
    NSString* fileName = [self.localMediaContent.filePath lastPathComponent];
    NSString* dirName = [self.localMediaContent.filePath substringToIndex:(self.localMediaContent.filePath.length - fileName.length)];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if(![filemgr fileExistsAtPath:dirName]) {
        [filemgr createDirectoryAtPath:dirName withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    [[TWRDownloadManager sharedManager] downloadFileForURL:self.localMediaContent.mediaContent.url withName:fileName inDirectoryNamed:dirName progressBlock:^(CGFloat progress) {
        NSLog(@"progress %f", progress);
        progressBlock(progress);
    } completionBlock:^(BOOL completed) {
        completionBlock(completed);
    } enableBackgroundMode:NO];
    
}

@end
