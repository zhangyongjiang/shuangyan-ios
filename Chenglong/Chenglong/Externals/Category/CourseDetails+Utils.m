//
//  CourseDetails+Utils.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 8/5/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "CourseDetails+Utils.h"

@implementation CourseDetails (Utils)

-(BOOL)isDirectory
{
    BOOL isdir = self.course.isDir.integerValue == 1;
    return isdir;
}

-(BOOL)hasChildren
{
    return self.items.count > 0;
}

@end
