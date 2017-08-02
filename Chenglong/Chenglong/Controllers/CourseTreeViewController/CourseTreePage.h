//
//  CourseTreePage.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 7/26/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "Page.h"
#import "UserView.h"
#import <RATreeView.h>

@interface CourseTreePage : Page

@property(assign, nonatomic)BOOL showUser;

@property(strong, nonatomic) UserSummaryView* userSummaryView;
@property(strong, nonatomic) RATreeView *treeView;
@property(strong, nonatomic) CourseDetails* courseDetails;
@property(strong, nonatomic) UIRefreshControl *refreshControl;

@end
