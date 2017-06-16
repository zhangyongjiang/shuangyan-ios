//
//  OrderItemView.m
//
//
//  Created by Kevin Zhang on 1/3/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

#import "OnlineFileListItemView.h"

@interface OnlineFileListItemView()

@property(strong, nonatomic) UIImageView* iconView;
@property(strong, nonatomic) FitLabel* label;

@end


@implementation OnlineFileListItemView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.clipsToBounds = YES;
    self.layer.masksToBounds = YES;
    
    self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 32, 32)];
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.iconView];
    
    self.label = [[FitLabel alloc] init];
    self.label.x = 44;
    [self addSubview:self.label];

    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self.label vcenterInParent];
    [self.iconView vcenterInParent];
}

-(void)setCourseDetails:(CourseDetails *)courseDetails {
    _courseDetails = courseDetails;
    self.label.text = courseDetails.course.title;
    if(courseDetails.course.isDir.intValue)
        self.iconView.image = [UIImage imageNamed:@"folder-128"];
    else
        self.iconView.image = [UIImage imageNamed:@"file-128"];
}
@end
