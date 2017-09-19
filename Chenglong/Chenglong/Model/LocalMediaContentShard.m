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
    BOOL enough = (f.length>=(self.offset+self.expectedDownloadSize));
    if(!enough)
        return NO;
    int len = 10;
    NSData* data = [f getDataAtOffset:self.offset length:len];
    if(!enough || data.length < len)
        return NO;
    uint8_t* buff = data.bytes;
    int total=0;
    for(int i=0; i<len; i++) {
        total += buff[i];
    }
    return total!=45;
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
    NSString* url = NULL;
    if([self.localMediaContent.url containsString:@"?"])
        url = [NSString stringWithFormat:@"%@&offset=%d&length=%d", self.localMediaContent.url, offset, length];
    else
        url = [NSString stringWithFormat:@"%@?offset=%d&length=%d", self.localMediaContent.url, offset, length];

    if(![url containsString:@"aliyuncs.com"])
        url = [NSString stringWithFormat:@"%@&access_token=%@", url, AppDelegate.userAccessToken];
    return url;
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

-(void)directDownload
{
    NSString* range = [NSString stringWithFormat:@"bytes=%ld-%ld", self.offset, (self.offset + self.expectedDownloadSize-1)];
    NSURL *url = [NSURL URLWithString:self.url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request setValue:range forHTTPHeaderField:@"Range"];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
//    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.url]];
    [self copyDownloadedFile:NULL orData:data withObject:self];
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


-(BOOL)copyDownloadedFile:(NSURL *)location withObject:(id)object {
    return [self copyDownloadedFile:location orData:NULL withObject:object];
}

-(BOOL)copyDownloadedFile:(NSURL *)location orData:(NSData*)data withObject:(id)object {
    NSLog(@"save shard %i to location %@", self.shard, self.localFilePath);
    
    File* f = [[File alloc] initWithFullPath:self.localFilePath];
    [f mkdirs];
    if(location) {
        NSError* error;
        NSLog(@"from location %@", location.absoluteString);
        [[NSFileManager defaultManager] moveItemAtURL:location
                                                toURL:[NSURL fileURLWithPath:self.localFilePath]
                                                error:&error];
        if (error) {
            NSLog(@"ERROR: %@", error);
            return NO;
        }
        if(f.length != self.expectedDownloadSize) {
            NSLog(@"ERROR expected file len:%d, got %ld", self.expectedDownloadSize, f.length);
            toast(@"文件下载错误");
            return NO;
        }
    }
    else if (data) {
        if(f.exists) {
            [f remove];
        }
        NSLog(@"from data len %lu", data.length);
        [[NSFileManager defaultManager] createFileAtPath:self.localFilePath contents:data attributes:nil];
    }
    else {
        NSLog(@"ERROR!!!!");
        return NO;
    }
    
    NSString* parentPath = self.localMediaContent.localFilePath;
    File* file = [[File alloc] initWithFullPath:parentPath];
    if(!file.exists ) {
        [file createFile];
    }
    if(file.length < self.offset) {
        long len = self.offset - file.length;
        uint8_t *bytes = malloc(sizeof(uint8_t) * len);
        for(int i=0; i<len; i++) {
            *(bytes+i) = i%10;
        }
        NSData* data = [NSData dataWithBytes:bytes length:len];
        NSFileHandle*  fileHandle = [NSFileHandle fileHandleForWritingAtPath:parentPath];
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:data];
        [fileHandle closeFile];
        free(bytes);
        NSLog(@"padding from %ld length %ld. new parent file length %ld", self.offset, len, file.length);
    }
    
    NSData* content = [NSData dataWithContentsOfFile:self.localFilePath];
    NSLog(@"append shard %i/%i data to %@ at offset %ld length %lu", self.shard, self.localMediaContent.numOfShards, parentPath, self.offset, (unsigned long)content.length);
    NSFileHandle*  fileHandle = [NSFileHandle fileHandleForWritingAtPath:parentPath];
    [fileHandle seekToFileOffset:self.offset];
    [fileHandle writeData:content];
    [fileHandle closeFile];
    
    [self deleteFile];
    
    if(self.localMediaContent.isDownloaded) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationDownloadCompleted object:self.localMediaContent];
    }
    return YES;
}
@end
