//
//  CourseDetailsView.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/10/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "BaseView.h"
#import "Page.h"
#import "LocalCourseDetails.h"

@interface CourseDetailsView : Page

@property(strong, nonatomic)LocalCourseDetails* localCourseDetails;

-(id)initWithFrame:(CGRect)frame andCourseDetails:(LocalCourseDetails*)localCourseDetails;
-(void)downloadAll;

@end
