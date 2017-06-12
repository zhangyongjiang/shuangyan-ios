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

@property(strong,nonatomic) FitLabel* labelDesc;
@property(strong,nonatomic) NSMutableArray* mediaContentViews;

@end

@implementation CourseDetailsView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

-(void)setup {
    self.labelDesc = [[FitLabel alloc] initWithFrame:CGRectMake(Margin, Margin, 0, 0)];
    self.labelDesc.numberOfLines = -1;
    [self addSubview:self.labelDesc];
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
    
    NSString* desc = [NSString stringWithFormat:@"Description: %@", self.localCourseDetails.courseDetails.course.content];
    self.labelDesc.text = desc;
    
    CGFloat w = [UIView screenWidth];
    CGFloat h = 400;
    CGFloat y = self.labelDesc.bottom + Margin;
    for (MediaContent* mc in self.localCourseDetails.courseDetails.course.resources) {
        MediaConentView* view = [MediaConentView createViewForMediaContent:mc andFilePath:self.localCourseDetails.filePath];
        if(view) {
            view.frame = CGRectMake(Margin, y, w, h);
            [self addSubview:view];
            y = y + h + Margin;
            [self.mediaContentViews addObject:view];
        }
    }
}

@end
