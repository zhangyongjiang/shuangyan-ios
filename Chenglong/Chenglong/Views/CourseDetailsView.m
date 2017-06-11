//
//  CourseDetailsView.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/10/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "CourseDetailsView.h"

@interface CourseDetailsView()

@property(strong,nonatomic) FitLabel* labelDesc;
@property(strong,nonatomic) NSMutableArray* mediaContentViews;

@end

@implementation CourseDetailsView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    self.labelDesc = [[FitLabel alloc] initWithFrame:CGRectMake(Margin, Margin, 0, 0)];
    self.labelDesc.numberOfLines = -1;
    [self addSubview:self.labelDesc];
    
    self.mediaContentViews = [NSMutableArray arrayWithCapacity:0];
    
    return self;
}

-(void)setCourseDetails:(CourseDetails *)courseDetails {
    for (UIView* view in self.mediaContentViews) {
        [view removeFromSuperview];
    }
    self.mediaContentViews = [NSMutableArray arrayWithCapacity:0];
    
}

@end
