//
//  OnlineFileListHeaderView.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/28/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "OnlineFileListHeaderView.h"
#import "CoursePathView.h"

@interface OnlineFileListHeaderView()

@property(strong,nonatomic)CoursePathView* coursePathView;

@end

@implementation OnlineFileListHeaderView

-(id)initWithFrame:(CGRect)frame andCourseDetailsWithParent:(CourseDetailsWithParent *)courseDetailsWithParent{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor colorFromHex:0xeeeeee];
    
    self.coursePathView = [[CoursePathView alloc] initWithFrame:self.bounds andUser:courseDetailsWithParent.courseDetails.user andCourseParent:courseDetailsWithParent.parent];
    [self addSubview:self.coursePathView];
    self.height = self.coursePathView.height;
    return self;
}

@end
