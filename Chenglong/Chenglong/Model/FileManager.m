//
//  FileManager.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/16/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager

+(void)saveCourseDetails:(CourseDetails *)courseDetails {
    
}

+(NSString*)getDirForId:(NSString*)sid {
    NSString* d0 = [sid substringToIndex:2];
    NSString* remain = [sid substringFromIndex:2];
    NSString* d1 = [remain substringToIndex:2];
    remain = [remain substringFromIndex:2];
    NSString* d2 = [remain substringToIndex:2];
    remain = [remain substringFromIndex:2];
    return [NSString stringWithFormat:@"%@/%@/%@/%@", d0, d1, d2, sid];
}

@end
