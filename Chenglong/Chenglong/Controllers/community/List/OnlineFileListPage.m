//
//  OnlineFileListPage.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "OnlineFileListPage.h"
#import "OnlineFileListViewController.h"
#import "OnlineFileListTableViewCell.h"
#import "WebViewController.h"
#import "OnlineFileDetailsViewController.h"

#define OnlineFileListItemTableViewCellID @"OnlineFileListItemTableViewCellID"

@implementation OnlineFileListPage

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [_tableView registerClass:[OnlineFileListTableViewCell class] forCellReuseIdentifier:OnlineFileListItemTableViewCellID];
    
    return self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.courseDetailsWithParent.courseDetails.items.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self checkNextPageForTableView:tableView indexPath:indexPath];
    OnlineFileListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:OnlineFileListItemTableViewCellID];
    CourseDetails* item = [self.courseDetailsWithParent.courseDetails.items objectAtIndex:indexPath.row];
//    cell.textLabel.text = item.course.title;
    cell.courseDetails = item;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseDetails* cd = [self.courseDetailsWithParent.courseDetails.items objectAtIndex:indexPath.row];
    if(cd.course.isDir.intValue == 1) {
        OnlineFileListViewController* c = [[OnlineFileListViewController alloc] init];
        c.courseId = cd.course.id;
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPushController object:tableView userInfo:[NSDictionary  dictionaryWithObjectsAndKeys:c, @"controller",nil]];
    }
    else {
        OnlineFileDetailsViewController* c = [[OnlineFileDetailsViewController alloc] init];
        c.courseId = cd.course.id;
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPushController object:tableView userInfo:[NSDictionary  dictionaryWithObjectsAndKeys:c, @"controller",nil]];
    }
}

-(void)setCourseDetailsWithParent:(CourseDetailsWithParent *)courseDetailsWithParent {
    _courseDetailsWithParent = courseDetailsWithParent;
    OnlineFileListHeaderView* headerView = [[OnlineFileListHeaderView alloc] initWithFrame:CGRectMake(0, 0, [UIView screenWidth], 30) andCourseDetailsWithParent:courseDetailsWithParent];
//    _tableView.tableHeaderView = headerView;
    [_tableView reloadData];
    if(courseDetailsWithParent.courseDetails.items.count == 0)
        [self setEmptyPageText:@"空文件夹"];
}

@end
