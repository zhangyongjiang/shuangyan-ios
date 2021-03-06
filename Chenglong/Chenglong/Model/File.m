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
    if(name) {
        if([dir hasSuffix:@"/"])
            self.fullPath = [NSString stringWithFormat:@"%@%@", dir, name];
        else
            self.fullPath = [NSString stringWithFormat:@"%@/%@", dir, name];
    }
    else
        self.fullPath = dir;
    return self;
}

-(NSString*)getExt {
    return [self.fullPath pathExtension];
//    int index = [self.name indexOf:@"."];
//    if(index == -1)
//        return NULL;
//    return [self.name substringFromIndex:(index+1)];
}

-(void)mkdirs {
    NSFileManager* fm = [NSFileManager defaultManager];
    NSError* err;
    NSString* dir = self.dir;
    if([self isDir])
        dir = self.fullPath;
    [fm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:NULL error:&err];
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
    BOOL isDirectory;
    return [fm fileExistsAtPath:self.fullPath isDirectory:&isDirectory];
}

-(BOOL)isDir {
    NSFileManager* fm = [NSFileManager defaultManager];
    BOOL isDirectory;
    BOOL exist = [fm fileExistsAtPath:self.fullPath isDirectory:&isDirectory];
    return exist ? isDirectory : NO;
}

-(BOOL)isFile {
    NSFileManager* fm = [NSFileManager defaultManager];
    BOOL isDirectory;
    BOOL exist = [fm fileExistsAtPath:self.fullPath isDirectory:&isDirectory];
    return exist ? !isDirectory : NO;
}

-(File*)parent {
    NSArray* array = [self.fullPath pathComponents];
    NSMutableArray* ma = [NSMutableArray arrayWithArray:array];
    [ma removeObjectAtIndex:(array.count-1)];
    NSString* parentPath = [NSString pathWithComponents:ma];
    File* parent = [[File alloc] initWithFullPath:parentPath];
    return parent;
}

-(NSMutableArray*)deepLs {
    NSMutableArray* ma = [NSMutableArray new];
    [self addAllChildrenToArray:ma];
    return ma;
}

-(void)addAllChildrenToArray:(NSMutableArray*)array {
    NSArray* items = [self ls];
    for (File* child in items) {
        if([child isFile]) {
            [array addObject:child];
        }
        else {
            [array addObjectsFromArray:[child deepLs]];
        }
    }
}

-(NSArray*)ls {
    if(![self isDir])
        return nil;
    NSDirectoryEnumerator *direnum = [[NSFileManager defaultManager] enumeratorAtPath:self.fullPath];
    NSMutableArray* array = [NSMutableArray new];
    NSString *filename;
    while ((filename = [direnum nextObject] )) {
        NSString *path = [self.fullPath stringByAppendingPathComponent:filename];
        File* f = [[File alloc] initWithFullPath:path];
        [array addObject:f];
    }
    return array;
}

+(NSString*)homeDir {
//    return NSHomeDirectory();
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    return documentsPath;
}

+(NSString*)mediaHomeDir {
    return [NSString stringWithFormat:@"%@/media", [File homeDir]];
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

-(void)remove
{
    NSFileManager* fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:self.fullPath error:nil];
}

-(void)createFile
{
    [[NSFileManager defaultManager] createFileAtPath:self.fullPath contents:nil attributes:nil];
}

-(NSData *)getDataAtOffset:(long)offset length:(int)len
{
    NSFileHandle*  fileHandle = [NSFileHandle fileHandleForReadingAtPath:self.fullPath];
    [fileHandle seekToFileOffset:offset];
    NSData *data = [fileHandle readDataOfLength:len];
    return data;

}
@end
