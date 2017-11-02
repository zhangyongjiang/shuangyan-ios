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
@property(assign, nonatomic)int repeat;
@property(assign, nonatomic)BOOL fullscreen;

@end

@implementation PlayListPage

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.playList = [NSMutableArray new];
    self.repeat = RepeatNone;
    self.fullscreen = NO;
    
    self.playerView = [[PlayerView alloc] initWithFrame:CGRectMake(0, 0,UIView.screenWidth, UIView.screenWidth*0.75)];
    [self addSubview:self.playerView];
    
    self.courseListPage = [[CourseListPage alloc] initWithFrame:CGRectMake(0, self.playerView.bottom, self.playerView.width, self.height-self.playerView.height)];
    [self addSubview:self.courseListPage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd:) name:NotificationPlayEnd object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(courseReplay:) name:NotificationCourseReplay object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleFullscreen) name:NotificationFullscreen object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(repeatNoti:) name:NotificationRepeat object:nil];

    return self;
}

-(void)repeatNoti:(NSNotification*)noti
{
    NSNumber* num = noti.object;
    int repeat = num.intValue;
    self.repeat = repeat;
}

-(void)toggleFullscreen
{
    if ([AppDelegate isLandscape])
        return;
    if(!self.fullscreen) {
        self.fullscreen = YES;
        self.playerView.frame = self.bounds;
        self.courseListPage.hidden = YES;
    } else {
        self.fullscreen = NO;
        self.playerView.frame = CGRectMake(0, 0,UIView.screenWidth, UIView.screenWidth*0.75);
        self.courseListPage.hidden = NO;
    }
}

-(void)courseReplay:(NSNotification*)noti
{
    CourseDetails* next = noti.object;
    self.playerView.courseDetails = next;
    [self.playerView play];
}

-(void)playEnd:(NSNotification*)noti
{
    CourseDetails* task = noti.object;
    for (int i=self.playList.count-1; i>=0; i--) {
        CourseDetails* item = [self.playList objectAtIndex:i];
        Course* parent = task.course;
        if([item.course.id isEqualToString:parent.id]) {
            if(self.repeat == RepeatOne) {
                CourseDetails* next = [self.playList objectAtIndex:i];
                self.playerView.courseDetails = next;
                [self.playerView play];
                return;
            }
            
            i++;
            if(i == self.playList.count) {
                if(self.repeat == RepeatAll)
                    i = 0;
                else
                    return;
            }
            CourseDetails* next = [self.playList objectAtIndex:i];
            self.playerView.courseDetails = next;
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
        if(self.fullscreen) {
            self.playerView.frame = self.bounds;
            self.courseListPage.hidden = YES;
        } else {
            self.playerView.frame = CGRectMake(0, 0,UIView.screenWidth, UIView.screenWidth*0.75);
            self.courseListPage.hidden = NO;
        }
    }
}

-(void)addCourseDetailsList:(NSMutableArray *)courseDetailsList
{
    NSMutableArray* holder = [NSMutableArray new];
    for (CourseDetails* item in courseDetailsList) {
        [self listFile:item toArray:holder];
    }
    [self.playList addObjectsFromArray:holder];
    self.courseListPage.courseList = self.playList;
    if(holder.count == self.playList.count) {
        CourseDetails* courseDetails = [holder objectAtIndex:0];
        self.playerView.courseDetails = courseDetails;
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
    self.playerView.courseDetails = courseDetails;
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
