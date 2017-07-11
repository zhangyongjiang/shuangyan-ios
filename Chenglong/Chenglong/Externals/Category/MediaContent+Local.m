//
//  MediaContent+Local.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 7/11/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "MediaContent+Local.h"
#import "LocalMediaContent.h"

@implementation MediaContent (Local)

-(BOOL)isDownloaded
{
    return [[[LocalMediaContent alloc] initWithMediaContent:self] isDownloaded];
}

@end
