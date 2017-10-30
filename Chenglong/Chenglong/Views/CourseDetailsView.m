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
{
    DeleteCourseResourceCallback deleteCallback;
}

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

-(void)dealloc
{
    for (MediaConentView* view in self.mediaContentViews) {
        [view removeFromSuperview];
    }
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

-(id)initWithFrame:(CGRect)frame andCourseDetails:(CourseDetails *)courseDetails {
    self = [super initWithFrame:frame];
    [self setup];
    [self setCourseDetails:courseDetails];
    return self;
}

-(void)setCourseDetails:(CourseDetails *)courseDetails {
    _courseDetails = courseDetails;
    for (UIView* view in self.mediaContentViews) {
        [view removeFromSuperview];
    }
    self.mediaContentViews = [NSMutableArray arrayWithCapacity:0];
    
    self.labelDesc.text = self.courseDetails.course.content;
    [self.labelDesc sizeToFit];
    
    CGFloat y = self.labelDesc.bottom;
    if(y>0.1)
        y += Margin;

    MediaConentView* view = [MediaConentView createViewForCourseDetails:self.courseDetails];
    if(view) {
        view.y = y;
        [self.scrollView addSubview:view];
        y = y + view.height + Margin;
        [self.mediaContentViews addObject:view];
    }

    self.scrollView.contentSize = CGSizeMake(self.width, y+128);
}

-(void)removeResource:(MediaContent*)mc {
    if(deleteCallback)
        deleteCallback(mc);
}

-(void)addRemoveResourceHandler:(DeleteCourseResourceCallback)callback {
    deleteCallback = callback;
}

@end
