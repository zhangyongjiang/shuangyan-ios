//
//  CourseDetailsView.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/10/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "BaseView.h"
#import "Page.h"
#import "CourseDetails.h"

@interface OnlineCourseDetailsView : Page

@property(strong, nonatomic)CourseDetails* courseDetails;

-(id)initWithFrame:(CGRect)frame andCourseDetails:(CourseDetails*)courseDetails;

@end
