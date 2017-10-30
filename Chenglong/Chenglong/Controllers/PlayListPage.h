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

@property(strong, nonatomic) NSMutableArray* playList;

-(void)addCourseDetails:(CourseDetails*)courseDetails;
-(void)addCourseDetailsToBeginning:(CourseDetails*)courseDetails;
-(void)addCourseDetailsList:(NSMutableArray*)courseDetailsList;
-(void)addCourseDetailsListToBeginning:(NSMutableArray*)courseDetailsList;

@end
