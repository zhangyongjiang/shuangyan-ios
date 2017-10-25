//
//  PlayListPage.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 10/21/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "PlayListPage.h"

@implementation PlayListPage

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    self.playerView = [[PlayerView alloc] initWithFrame:CGRectMake(0, 0,UIView.screenWidth, UIView.screenWidth*0.75)];
    [self addSubview:self.playerView];
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        self.playerView.frame = self.bounds;
    } else {
        self.playerView.frame = CGRectMake(0, 0, UIView.screenWidth, UIView.screenWidth*0.75);
    }
}

-(void)addCourseDetails:(CourseDetails *)courseDetails
{
    LocalMediaContent* lmc = [courseDetails.course.resources objectAtIndex:0];
    lmc.parent = courseDetails.course;
    self.playerView.localMediaContent = lmc;
    [self.playerView play];
}
@end
