//
//  CourseDetailsView.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/10/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "CourseDetailsView.h"
#import "MediaConentView.h"

@interface CourseDetailsView()

@property(strong,nonatomic) UILabel* labelDesc;
@property(strong,nonatomic) NSMutableArray* mediaContentViews;
@property(strong,nonatomic) UIScrollView* scrollView;

@end

@implementation CourseDetailsView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

-(void)setup {
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    [self addSubview:self.scrollView];
    
    self.labelDesc = [[UILabel alloc] initWithFrame:CGRectMake(Margin, 0, [UIView screenWidth]-Margin*2, 0)];
    self.labelDesc.numberOfLines = 0;
    self.labelDesc.lineBreakMode = NSLineBreakByWordWrapping;
    [self.scrollView addSubview:self.labelDesc];
    self.mediaContentViews = [NSMutableArray arrayWithCapacity:0];
}

-(id)initWithFrame:(CGRect)frame andLocalCourseDetails:(LocalCourseDetails *)localCourseDetails {
    self = [super initWithFrame:frame];
    [self setup];
    [self setLocalCourseDetails:localCourseDetails];
    return self;
}

-(void)setLocalCourseDetails:(LocalCourseDetails *)localCourseDetails {
    _localCourseDetails = localCourseDetails;
    for (UIView* view in self.mediaContentViews) {
        [view removeFromSuperview];
    }
    self.mediaContentViews = [NSMutableArray arrayWithCapacity:0];
    
    self.labelDesc.text = self.localCourseDetails.courseDetails.course.content;
    [self.labelDesc sizeToFit];
    
    CGFloat y = self.labelDesc.bottom;
    if(y>0.1)
        y += Margin;
    for (MediaContent* mc in self.localCourseDetails.courseDetails.course.resources) {
        MediaConentView* view = [MediaConentView createViewForMediaContent:mc];
        if(view) {
            view.y = y;
            [self.scrollView addSubview:view];
            y = y + view.height + Margin;
            [self.mediaContentViews addObject:view];
        }
    }
    self.scrollView.contentSize = CGSizeMake(self.width, y);
}

@end
