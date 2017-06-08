//
//  OrderItemView.m
//
//
//  Created by Kevin Zhang on 1/3/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

#import "FileListItemView.h"

@interface FileListItemView()

@property(strong, nonatomic) FitLabel* label;

@end


@implementation FileListItemView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.clipsToBounds = YES;
    self.layer.masksToBounds = YES;
    
    self.label = [[FitLabel alloc] init];
    self.label.x = 15;
    [self addSubview:self.label];

    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self.label vcenterInParent];
}

-(void)setCourseDetails:(CourseDetails *)courseDetails {
    _courseDetails = courseDetails;
    self.label.text = courseDetails.course.title;
}
@end
