//
//  MediaConentView.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/10/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "MediaConentView.h"

@implementation MediaConentView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    return self;
}

+(BOOL)isImage:(MediaContent*)mediaContent {
    return [mediaContent.contentType hasPrefix:@"image"];
}
+(BOOL)isAudio:(MediaContent*)mediaContent {
    return [mediaContent.contentType hasPrefix:@"audio"];
}
+(BOOL)isVideo:(MediaContent*)mediaContent {
    return [mediaContent.contentType hasPrefix:@"video"];
}
+(BOOL)isPdf:(MediaContent*)mediaContent {
    return [mediaContent.contentType hasPrefix:@"application/pdf"];
}

-(BOOL)downloaded {
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSString* filePath = self.localMediaContent.filePath;
    if(![filemgr fileExistsAtPath:filePath isDirectory:nil]) {
        return NO;
    }
    unsigned long long fileSize = [[filemgr attributesOfItemAtPath:filePath error:nil] fileSize];
    if(fileSize != [self.localMediaContent.mediaContent.length longLongValue]) {
        return NO;
    }
    return YES;
}

@end
