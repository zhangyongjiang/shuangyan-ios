//
//  OfflineFilePage.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/8/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "OfflineFilePage.h"

@implementation OfflineFilePage

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

-(BOOL)downloaded {
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if(![filemgr fileExistsAtPath:self.offline isDirectory:nil])
        return NO;
    unsigned long long fileSize = [[filemgr attributesOfItemAtPath:self.offline error:nil] fileSize];
    if(fileSize != [self.online.length longLongValue])
        return NO;
    return YES;
}

-(void)download {
    NSData *urlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.online.url]];
    [urlData writeToFile:self.offline atomically:YES];
}
@end
