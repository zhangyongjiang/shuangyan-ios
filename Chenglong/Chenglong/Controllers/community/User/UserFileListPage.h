//
//  FileListPage.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "TableViewPage.h"
#import "CourseDetailsList.h"

@interface UserFileListPage : TableViewPage

@property(strong, nonatomic) CourseDetailsWithParent* courseDetailsWithParent;

-(CourseDetails*) selected;

@end
