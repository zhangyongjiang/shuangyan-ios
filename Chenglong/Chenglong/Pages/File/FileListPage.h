//
//  FileListPage.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "TableViewPage.h"
#import "CourseDetailsList.h"

@interface FileListPage : TableViewPage

@property(strong, nonatomic) CourseDetailsList* courseDetailsList;
@property(strong, nonatomic) NSString* filePath;

-(CourseDetails*) selected;

@end
