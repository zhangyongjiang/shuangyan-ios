//
//  FileListViewController.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "BaseViewController.h"
#import "FileListPage.h"

@interface FileListViewController : BaseViewController

@property(strong, nonatomic) NSString* currentCourseId;
@property(strong, nonatomic) NSString* currentDirPath;

@end
