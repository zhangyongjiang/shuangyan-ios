//
//  PlayListPage.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 10/21/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "Page.h"
#import "PlayerView.h"

@interface PlayListPage : Page

@property(strong, nonatomic)PlayerView* playerView;

-(void)addCourseDetails:(CourseDetails*)courseDetails;
-(void)addCourseDetailsList:(NSMutableArray*)courseDetailsList;

@end
