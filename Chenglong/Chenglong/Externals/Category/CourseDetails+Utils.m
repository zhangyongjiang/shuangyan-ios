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

-(CourseDetails*)nextSibling
{
    if(self.parent == NULL)
        return NULL;
    BOOL foundSelf = NO;
    for (CourseDetails* child in self.parent.items) {
        if(!foundSelf) {
            if([child.course.id isEqualToString:self.course.id]) {
                foundSelf = YES;
            }
        }
        else {
            return child;
        }
    }
    return NULL;
}

-(LocalMediaContent*)nextMediaContent:(LocalMediaContent*)content
{
    BOOL foundSelf = NO;
    for (LocalMediaContent* child in self.course.resources) {
        if(content == NULL) {
            return child;
        }
        if(!foundSelf) {
            if([child.path isEqualToString:content.path]) {
                foundSelf = YES;
            }
        }
        else {
            return child;
        }
    }
    
    CourseDetails* sibling = [self nextSibling];
    return [sibling nextMediaContent:NULL];
}

@end
