//
//  CoursePathView.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/29/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "CoursePathView.h"

@interface CoursePathView()
@property(strong,nonatomic) CourseDetailsWithParent *courseDetailsWithParent;
@end

@implementation CoursePathView

-(id)initWithFrame:(CGRect)frame andCourseDetailsWithParent:(CourseDetailsWithParent *)courseDetailsWithParent {
    self = [super initWithFrame:frame];
    self.courseDetailsWithParent = courseDetailsWithParent;
    
    FitLabel* userLabel = [[FitLabel alloc] initWithFrame:CGRectMake(Margin, Margin, 0, 0)];
    userLabel.text = [NSString stringWithFormat:@"上传者: %@", courseDetailsWithParent.courseDetails.user.name];
    [self addSubview:userLabel];
    
    CourseParent* cp = [CourseParent new];
    cp.course = courseDetailsWithParent.courseDetails.course;
    cp.parent = courseDetailsWithParent.parent;
    CGFloat y = [self addParentLabel:cp atPositiony:userLabel.bottom];
    self.height = y;
    
    return self;
}

-(CGFloat)addParentLabel:(CourseParent*)courseParent atPositiony:(CGFloat)y{
    if(courseParent.parent) {
        y = [self addParentLabel:courseParent.parent atPositiony:y];
    }
    FitLabel* label = [[FitLabel alloc] initWithFrame:CGRectMake(Margin, y, 0, 0)];
    label.text = [NSString stringWithFormat:@"  -- %@", courseParent.course.title];
    [self addSubview:label];
    return label.bottom;
}

@end
