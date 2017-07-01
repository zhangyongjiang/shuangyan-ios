//
//  CourseDetailsView.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/10/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "OnlineCourseDetailsView.h"
#import "OnlineCourseResourceView.h"
#import "UserView.h"
#import "CourseSummaryView.h"
#import "CoursePathView.h"

@interface OnlineCourseDetailsView()

@property(strong,nonatomic) CoursePathView* coursePathView;
@property(strong,nonatomic) OnlineCourseResourceView* resourcesView;
@property(strong,nonatomic) UILabel* labelDesc;
@property(strong,nonatomic) UIScrollView* scrollView;

@end

@implementation OnlineCourseDetailsView

-(id)initWithFrame:(CGRect)frame andCourseDetailsWithParent:(CourseDetailsWithParent *)courseDetailsWithParent {
    self = [super initWithFrame:frame];
    [self setCourseDetailsWithParent:courseDetailsWithParent];
    return self;
}

-(void)setCourseDetailsWithParent:(CourseDetailsWithParent *)courseDetailsWithParent {
    _courseDetailsWithParent = courseDetailsWithParent;

    if(self.scrollView) {
        [self.scrollView rectForSubviews];
    }
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIView screenWidth], [UIView screenHeight])];
    [self addSubview:self.scrollView];
    
    CGFloat y = 0;
    self.coursePathView = [[CoursePathView alloc] initWithFrame:CGRectMake(Margin, Margin, [UIView screenWidth], 40) andCourseDetailsWithParent:self.courseDetailsWithParent];
    [self.scrollView addSubview:self.coursePathView];
    y = self.coursePathView.bottom + Margin;

    if(courseDetailsWithParent.courseDetails.course.resources == NULL || courseDetailsWithParent.courseDetails.course.resources.count == 0) {
        self.resourcesView = [[OnlineCourseResourceView alloc] initWithFrame:CGRectMake(0, y, [UIView screenWidth], [UIView screenWidth]*3/4)];
        self.resourcesView.scrollView.height = self.resourcesView.height;
        self.resourcesView.courseResources = courseDetailsWithParent.courseDetails.course.resources;
        [self.scrollView addSubview:self.resourcesView];
        y = self.resourcesView.bottom + Margin;
    }
    
    self.labelDesc = [[UILabel alloc] initWithFrame:CGRectMake(Margin, y, [UIView screenWidth]-Margin*2, 0)];
    self.labelDesc.numberOfLines = 0;
    self.labelDesc.lineBreakMode = NSLineBreakByWordWrapping;
    [self.scrollView addSubview:self.labelDesc];
    self.labelDesc.text = self.courseDetailsWithParent.courseDetails.course.content;
    [self.labelDesc sizeToFit];
    y = self.labelDesc.bottom + Margin;
    
    self.scrollView.contentSize = CGSizeMake(self.width, y);
    
}

@end
