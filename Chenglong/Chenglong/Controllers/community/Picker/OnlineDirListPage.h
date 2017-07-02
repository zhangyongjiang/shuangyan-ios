//
//  FileListPage.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "TableViewPage.h"
#import "CourseDetailsList.h"

@interface OnlineDirListPage : TableViewPage

@property(strong, nonatomic) CourseDetailsList* courseDetailsList;
@property(weak, nonatomic) id delegate;

-(CourseDetails*) selected;

@end
