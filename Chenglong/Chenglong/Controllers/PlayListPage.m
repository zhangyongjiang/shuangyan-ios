//
//  PlayListPage.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 10/21/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "PlayListPage.h"
#import "CourseListPage.h"

@interface PlayListPage()

@property(strong, nonatomic)PlayerView* playerView;
@property(strong, nonatomic)CourseListPage* courseListPage;

@end

@implementation PlayListPage

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.playList = [NSMutableArray new];
    
    self.playerView = [[PlayerView alloc] initWithFrame:CGRectMake(0, 0,UIView.screenWidth, UIView.screenWidth*0.75)];
    [self addSubview:self.playerView];
    
    self.courseListPage = [[CourseListPage alloc] initWithFrame:CGRectMake(0, self.playerView.bottom, self.playerView.width, self.height-self.playerView.height)];
    [self addSubview:self.courseListPage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd:) name:NotificationPlayEnd object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(courseReplay:) name:NotificationCourseReplay object:nil];

    return self;
}

-(void)courseReplay:(NSNotification*)noti
{
    CourseDetails* next = noti.object;
    LocalMediaContent* lmc = [next.course.resources objectAtIndex:0];
    lmc.parent = next.course;
    self.playerView.localMediaContent = lmc;
    [self.playerView play];
}

-(void)playEnd:(NSNotification*)noti
{
    LocalMediaContent* task = noti.object;
    for (int i=self.playList.count-1; i>=0; i--) {
        CourseDetails* item = [self.playList objectAtIndex:i];
        if([item.course.id isEqualToString:task.parent.id]) {
            i++;
            if(i == self.playList.count)
                i = 0;
            CourseDetails* next = [self.playList objectAtIndex:i];
            LocalMediaContent* lmc = [next.course.resources objectAtIndex:0];
            lmc.parent = next.course;
            self.playerView.localMediaContent = lmc;
            [self.playerView play];
            return;
        }
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        self.playerView.frame = self.bounds;
        self.courseListPage.hidden = YES;
    } else {
        self.playerView.frame = CGRectMake(0, 0, UIView.screenWidth, UIView.screenWidth*0.75);
        self.courseListPage.hidden = NO;
    }
}

-(void)addCourseDetailsList:(NSMutableArray *)courseDetailsList
{
    NSMutableArray* holder = [NSMutableArray new];
    for (CourseDetails* item in courseDetailsList) {
        [self listFile:item toArray:holder];
    }
    NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:
                           NSMakeRange(0,holder.count)];
    [self.playList insertObjects:holder atIndexes:indexes];
    self.courseListPage.courseList = self.playList;
    if(holder.count == self.playList.count) {
        CourseDetails* courseDetails = [holder objectAtIndex:0];
        LocalMediaContent* lmc = [courseDetails.course.resources objectAtIndex:0];
        lmc.parent = courseDetails.course;
        self.playerView.localMediaContent = lmc;
        [self.playerView play];
    }
}

-(void)addCourseDetails:(CourseDetails *)courseDetails
{
    [self addCourseDetailsList:[NSMutableArray arrayWithObject:courseDetails]];
}

-(void)addCourseDetailsToBeginning:(CourseDetails *)courseDetails
{
    [self addCourseDetailsListToBeginning:[NSMutableArray arrayWithObject:courseDetails]];
}

-(void)addCourseDetailsListToBeginning:(NSMutableArray *)courseDetailsList
{
    NSMutableArray* holder = [NSMutableArray new];
    for (CourseDetails* item in courseDetailsList) {
        [self listFile:item toArray:holder];
    }
    NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:
                           NSMakeRange(0,holder.count)];
    [self.playList insertObjects:holder atIndexes:indexes];
    self.courseListPage.courseList = self.playList;

    CourseDetails* courseDetails = [holder objectAtIndex:0];
    LocalMediaContent* lmc = [courseDetails.course.resources objectAtIndex:0];
    lmc.parent = courseDetails.course;
    self.playerView.localMediaContent = lmc;
    [self.playerView play];
}

-(void)setPlayList:(NSMutableArray *)playList {
    _playList = playList;
    if(playList.count == 0) {
        [self.playerView stop];
    }
    self.courseListPage.courseList = playList;
}

-(void)listFile:(CourseDetails*)cd toArray:(NSMutableArray*)holder {
    if(![cd isDirectory]) {
        [holder addObject:cd];
        return;
    }
    for (CourseDetails* child in cd.items) {
        if(child.isDirectory) {
            [self listFile:child toArray:holder];
        }
        else
            [holder addObject:child];
    }
}

@end
