//
//  FileListViewController.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "BaseViewController.h"
#import "OnlineFileListPage.h"

@interface OnlineFileListViewController : BaseViewController

@property(strong, nonatomic) NSString* courseId;
@property(strong, nonatomic) NSString* filePath;

@end
