//
//  CourseNameView.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 7/1/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "CourseNameView.h"

@implementation CourseNameView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self addTarget:self action:@selector(courseSelected)];
    return self;
}

-(void)courseSelected {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationCourseSelected object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.courseId, @"courseId", nil]];
}
@end
