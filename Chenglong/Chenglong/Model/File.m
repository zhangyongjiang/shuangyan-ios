//
//  File.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/18/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "File.h"

@implementation File

-(id)initWithFullPath:(NSString *)path {
    self = [super init];
    self.fullPath = path;
    self.name = [path lastPathComponent];
    self.dir = [path substringToIndex:(path.length-self.name.length)];
    return self;
}

-(id)initWithDir:(NSString *)dir andName:(NSString *)name {
    self = [super init];
    self.name = name;
    self.dir = dir;
    if([dir hasSuffix:@"/"])
        self.fullPath = [NSString stringWithFormat:@"%@%@", dir, name];
    else
        self.fullPath = [NSString stringWithFormat:@"%@/%@", dir, name];
    return self;
}

-(NSString*)getExt {
    int index = [self.name indexOf:@"."];
    if(index == -1)
        return NULL;
    return [self.name substringFromIndex:(index+1)];
}

-(void)mkdirs {
    NSFileManager* fm = [NSFileManager defaultManager];
    NSError* err;
    [fm createDirectoryAtPath:self.dir withIntermediateDirectories:YES attributes:NULL error:&err];
    if(err) {
        NSLog(@"cannot create dir %@. Cause: %@", self.dir, err);
    }
}

-(long)length {
    NSError* err;
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:self.fullPath error:&err];
    if(err) return -1;
    
    NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
    long long fileSize = [fileSizeNumber longLongValue];
    return (long)fileSize;
}

-(NSDate*)lastModifiedTime {
    NSError* err;
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:self.fullPath error:&err];
    if(err) return NULL;
    NSDate *date = [fileAttributes fileModificationDate];
    return date;
}

-(BOOL)exists {
    NSFileManager* fm = [NSFileManager defaultManager];
    return [fm fileExistsAtPath:self.fullPath];
}

-(NSData*)content {
    NSFileManager* fm = [NSFileManager defaultManager];
    return [fm contentsAtPath:self.fullPath];
}

-(void)setContent:(NSData *)content {
    [content writeToFile:self.fullPath atomically:YES];
}

-(void)writeStringContent:(NSString *)content {
    [content writeToFile:self.fullPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}
@end
