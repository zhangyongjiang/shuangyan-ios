//
//  FileListPage.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "TableViewPage.h"
#import "CourseDetailsList.h"

@interface CourseListPage : TableViewPage

@property(strong, nonatomic) NSMutableArray* courseList;

-(void)addCourseDetailsList:(NSMutableArray *)courseDetailsList;
-(void)addCourseDetails:(CourseDetails *)courseDetails;

@end
