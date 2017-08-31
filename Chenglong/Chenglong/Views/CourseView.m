//
//  CourseView.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 8/27/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "CourseView.h"
#import "GalleryView.h"
#import "MediaContentTextView.h"

@interface CourseView()

@end



@implementation CourseView


-(void)setCourseDetails:(CourseDetails *)courseDetails
{
    _courseDetails = courseDetails;
    [self showCourseDetails:courseDetails];
}

@end
