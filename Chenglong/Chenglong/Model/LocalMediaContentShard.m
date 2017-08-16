//
//  LocalMediaContentShard.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 8/13/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "LocalMediaContentShard.h"
#import "TWRDownloadManager.h"

@implementation LocalMediaContentShard

-(id)initWithLocalMediaContent:(LocalMediaContent *)localMediaContent andShard:(int)shard
{
    self = [super init];
    self.localMediaContent = localMediaContent;
    self.shard = shard;
    return self;
}

-(BOOL)isDownloaded
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

-(CMTime)duration
{
    NSURL *sourceMovieURL = [NSURL fileURLWithPath:self.localFilePath];
    AVURLAsset *sourceAsset = [AVURLAsset URLAssetWithURL:sourceMovieURL options:nil];
    CMTime duration = sourceAsset.duration;
    return duration;
}

-(NSData*)data {
    return [NSData dataWithContentsOfFile:self.localFilePath];
}

@end
