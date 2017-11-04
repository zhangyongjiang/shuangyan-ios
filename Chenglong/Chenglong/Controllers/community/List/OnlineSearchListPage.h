//
//  FileListPage.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "TableViewPage.h"
#import "CourseDetailsList.h"

@interface OnlineSearchListPage : TableViewPage

@property(strong, nonatomic) UITextField* txtFieldKeywords;
@property(strong, nonatomic) CourseDetailsList* courseDetailsList;

-(CourseDetails*) selected;
-(void)appendCourseDetailsList:(CourseDetailsList*) next;

@end
