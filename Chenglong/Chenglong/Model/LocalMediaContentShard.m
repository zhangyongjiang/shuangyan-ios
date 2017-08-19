//
//  LocalMediaContentShard.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 8/13/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "LocalMediaContentShard.h"
#import "TWRDownloadManager.h"

@interface LocalMediaContentShard() <DownloaderDelegate>

@property(copy, nonatomic)void (^progressCallback)(LocalMediaContentShard *, CGFloat) ;
@property(copy, nonatomic)void (^completionCallback)(LocalMediaContentShard *, BOOL) ;

@end

@implementation LocalMediaContentShard

-(id)initWithLocalMediaContent:(LocalMediaContent *)localMediaContent andShard:(int)shard
{
    self = [super init];
    self.localMediaContent = localMediaContent;
    self.shard = shard;
    return self;
}

-(BOOL)isInParent
{
    NSString* parentFilePath = self.localMediaContent.localFilePath;
    File* f = [[File alloc] initWithFullPath:parentFilePath];
    if(!f.exists)
        return NO;
    return f.length>=(self.offset+self.expectedDownloadSize);
}

-(BOOL)isInShard
{
    NSString* shardFilePath = [self localFilePath];
    File* f = [[File alloc] initWithFullPath:shardFilePath];
    if(!f.exists)
        return NO;
    if(self.shard != (self.localMediaContent.numOfShards-1))
        return (f.length == self.localMediaContent.shardSize);
    else
        return f.length == (self.localMediaContent.length.intValue - self.shard*self.localMediaContent.shardSize);
}

-(BOOL)isDownloaded
{
    BOOL inparent = self.isInParent;
    if(inparent)
        return YES;
    BOOL inshard = self.isInShard;
    if(inshard) {
        NSString* parentFilePath = self.localMediaContent.localFilePath;
        File* f = [[File alloc] initWithFullPath:parentFilePath];
        if(!f.exists)
            [[NSFileManager defaultManager] createFileAtPath:parentFilePath contents:nil attributes:nil];
        if(f.length == self.shard*self.localMediaContent.shardSize) {
            NSData* content = [NSData dataWithContentsOfFile:self.localFilePath];
            NSFileHandle*  fileHandle = [NSFileHandle fileHandleForWritingAtPath:parentFilePath];
            [fileHandle seekToFileOffset:self.offset];
            [fileHandle writeData:content];
            [fileHandle closeFile];
            [self deleteFile];
        }
    }
    return inshard;
}

-(BOOL)isDownloading
{
    return [[TWRDownloadManager sharedManager] isFileDownloadingForUrl:self.url];
}

-(NSString*)localFilePath {
    NSString* fname = self.localMediaContent.localFilePath;
    if([fname containsString:@"."]) {
        fname = [fname stringByReplacingOccurrencesOfString:@"." withString:[NSString stringWithFormat:@".%d.", self.shard]];
    }
    else
        fname = [NSString stringWithFormat:@"%@.%d", fname, self.shard];
    return fname;
}

-(NSString*)fileName {
    NSString* fname = self.localMediaContent.getFileName;
    if([fname containsString:@"."]) {
        fname = [fname stringByReplacingOccurrencesOfString:@"." withString:[NSString stringWithFormat:@".%d.", self.shard]];
    }
    else
        fname = [NSString stringWithFormat:@"%@.%d", fname, self.shard];
    return fname;
}

-(NSString*)dirName
{
    return self.localMediaContent.getDirName;
}

-(NSString*)url {
    int offset = self.shard * self.localMediaContent.shardSize;
    int length = self.localMediaContent.shardSize;
    if((offset + length)>self.localMediaContent.length.intValue)
        length = self.localMediaContent.length.intValue - offset;
    if([self.localMediaContent.url containsString:@"?"])
        return [NSString stringWithFormat:@"%@&offset=%d&length=%d", self.localMediaContent.url, offset, length];
    else
        return [NSString stringWithFormat:@"%@?offset=%d&length=%d", self.localMediaContent.url, offset, length];
}

-(long)offset {
    return self.shard * self.localMediaContent.shardSize;
}

-(int)expectedDownloadSize
{
    if(self.shard<(self.localMediaContent.numOfShards-1))
        return self.localMediaContent.shardSize;
    return self.localMediaContent.length.intValue - self.shard * self.localMediaContent.shardSize;
}

-(void)deleteFile
{
    File* f = [[File alloc] initWithFullPath:self.localFilePath];
    [f remove];
}

-(NSData*)data {
    if(self.isInShard)
        return [NSData dataWithContentsOfFile:self.localFilePath];
    else if(self.isInParent) {
        NSFileHandle*  fileHandle = [NSFileHandle fileHandleForReadingAtPath:self.localMediaContent.localFilePath];
        [fileHandle seekToFileOffset:self.offset];
        NSData *data = [fileHandle readDataOfLength:self.expectedDownloadSize];
        return data;
    }
    return NULL;
}

-(void)downloadWithProgressBlock:(void (^)(LocalMediaContentShard *, CGFloat))progressBlock completionBlock:(void (^)(LocalMediaContentShard *, BOOL))completionBlock enableBackgroundMode:(BOOL)backgroundMode {
    [self deleteFile];
    self.completionCallback = completionBlock;
    WeakSelf(weakSelf)
    [[TWRDownloadManager sharedManager] downloadFileForObject:self withURL:self.url progressBlock:progressBlock completionBlock:^(id object, BOOL completed) {
        [weakSelf downloadCompleted:completed];
    } enableBackgroundMode:backgroundMode];
}

-(void)downloadCompleted:(BOOL)completed {
    if(self.completionCallback != NULL) {
        self.completionCallback(self, completed);
    }
}

-(void)copyDownloadedFile:(NSURL *)location withObject:(id)object {
    NSLog(@"save shard %i to location %@", self.shard, self.localFilePath);
    NSError* error;
    File* f = [[File alloc] initWithFullPath:self.localFilePath];
    [f mkdirs];
    [[NSFileManager defaultManager] moveItemAtURL:location
                                            toURL:[NSURL fileURLWithPath:self.localFilePath]
                                            error:&error];
    if (error) {
        NSLog(@"ERROR: %@", error);
        return;
    }
    
    NSString* parentPath = self.localMediaContent.localFilePath;
    File* file = [[File alloc] initWithFullPath:parentPath];
    if(file.exists ) {
        if(file.length != self.offset) {
            NSLog(@"current shard is not the next one at %@", self.localMediaContent.localFilePath);
            return;
        }
    }
    else {
        [[NSFileManager defaultManager] createFileAtPath:parentPath contents:nil attributes:nil];
    }
    NSLog(@"append shard %i data to %@ at offset %ld", self.shard, parentPath, self.offset);
    NSData* content = [NSData dataWithContentsOfFile:self.localFilePath];
    NSFileHandle*  fileHandle = [NSFileHandle fileHandleForWritingAtPath:parentPath];
    [fileHandle seekToFileOffset:self.offset];
    [fileHandle writeData:content];
    [fileHandle closeFile];
    
    [self deleteFile];
}
@end
