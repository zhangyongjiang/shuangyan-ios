//
//  CourseSummaryView.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/25/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "CourseSummaryView.h"

@interface CourseSummaryView()

@property(strong, nonatomic) UILabel* labelLikes;

@end

@implementation CourseSummaryView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.clipsToBounds  = YES;
    
    self.labelLikes = [[UILabel alloc] initWithFrame:CGRectMake(Margin, Margin, 100, 20)];
    [self addSubview:self.labelLikes];
    
    return self;
}

-(void)setCourseDetails:(CourseDetails *)courseDetails {
    _courseDetails = courseDetails;
    self.labelLikes.text = [NSString stringWithFormat:@"%@ likes", courseDetails.info.likes];
}

@end
