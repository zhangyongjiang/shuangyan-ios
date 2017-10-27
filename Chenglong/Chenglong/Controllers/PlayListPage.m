//
//  PlayListPage.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 10/21/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "PlayListPage.h"

@interface PlayListPage()

@property(strong, nonatomic) NSMutableArray* playList;

@property(strong, nonatomic)PlayerView* playerView;

@end

@implementation PlayListPage

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.playList = [NSMutableArray new];
    
    self.playerView = [[PlayerView alloc] initWithFrame:CGRectMake(0, 0,UIView.screenWidth, UIView.screenWidth*0.75)];
    [self addSubview:self.playerView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd:) name:NotificationPlayEnd object:nil];
    
    return self;
}

-(void)playEnd:(NSNotification*)noti
{
    PlayTask* task = noti.object;
    for (int i=self.playList.count-1; i>=0; i--) {
        CourseDetails* item = [self.playList objectAtIndex:i];
        if([item.course.id isEqualToString:task.localMediaContent.parent.id]) {
            if(i<(self.playList.count-1)) {
                CourseDetails* next = [self.playList objectAtIndex:i+1];
                LocalMediaContent* lmc = [next.course.resources objectAtIndex:0];
                lmc.parent = item.course;
                self.playerView.localMediaContent = lmc;
                [self.playerView play];
            }
            [self.playList removeObjectAtIndex:i];
            break;
        }
    }
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

-(void)addCourseDetailsList:(NSMutableArray *)courseDetailsList
{
    [self.playList addObjectsFromArray:courseDetailsList];
    if(self.playList.count == courseDetailsList.count) {
        CourseDetails* first = [self.playList objectAtIndex:0];
        LocalMediaContent* lmc = [first.course.resources objectAtIndex:0];
        lmc.parent = first.course;
        self.playerView.localMediaContent = lmc;
        [self.playerView play];
    }
}

-(void)addCourseDetails:(CourseDetails *)courseDetails
{
    [self.playList addObject:courseDetails];
    if(self.playList.count == 1) {
        LocalMediaContent* lmc = [courseDetails.course.resources objectAtIndex:0];
        lmc.parent = courseDetails.course;
        self.playerView.localMediaContent = lmc;
        [self.playerView play];
    }
}
@end
