//
//  CourseDetailsView.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/10/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "OnlineCourseDetailsView.h"
#import "OnlineCourseResourceView.h"

@interface OnlineCourseDetailsView()

@property(strong,nonatomic) OnlineCourseResourceView* resourcesView;
@property(strong,nonatomic) UILabel* labelDesc;
@property(strong,nonatomic) UIScrollView* scrollView;

@end

@implementation OnlineCourseDetailsView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

-(void)setup {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIView screenWidth], [UIView screenHeight])];
    [self addSubview:self.scrollView];

    self.resourcesView = [[OnlineCourseResourceView alloc] initWithFrame:CGRectMake(0, 0, [UIView screenWidth], [UIView screenWidth]*3/4)];

    [self.scrollView addSubview:self.resourcesView];

    self.labelDesc = [[UILabel alloc] initWithFrame:CGRectMake(Margin, self.resourcesView.bottom, [UIView screenWidth]-Margin*2, 0)];
    self.labelDesc.numberOfLines = 0;
    self.labelDesc.lineBreakMode = NSLineBreakByWordWrapping;
    [self.scrollView addSubview:self.labelDesc];
}

-(id)initWithFrame:(CGRect)frame andCourseDetails:(CourseDetails *)courseDetails {
    self = [super initWithFrame:frame];
    [self setup];
    [self setCourseDetails:courseDetails];
    return self;
}

-(void)setCourseDetails:(CourseDetails *)courseDetails {
    _courseDetails = courseDetails;
    
    self.resourcesView.courseResources = courseDetails.course.resources;
    if(courseDetails.course.resources == NULL || courseDetails.course.resources.count == 0) {
        self.resourcesView.height = 0;
        self.labelDesc.y = 0;
    }
    else {
        self.resourcesView.height = [UIView screenWidth]*3/4;
        self.labelDesc.y = self.resourcesView.height;
    }
    self.labelDesc.text = self.courseDetails.course.content;
    [self.labelDesc sizeToFit];
    CGFloat y = self.labelDesc.bottom + Margin;
    self.scrollView.contentSize = CGSizeMake(self.width, y);
}

@end
