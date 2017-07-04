//
//  FileListViewController.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "BaseViewController.h"
#import "UserFileListPage.h"


@interface UserFileListViewController : BaseViewController

@property(strong, nonatomic) NSString* userId;
@property(strong, nonatomic) User* user;

@end
