//
//  UserFileListPage.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "UserFileListPage.h"
#import "UserFileListViewController.h"
#import "UserFileListTableViewCell.h"
#import "WebViewController.h"
#import "OnlineFileDetailsViewController.h"

#define UserFileListItemTableViewCellID @"UserFileListItemTableViewCellID"

@implementation UserFileListPage

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [_tableView registerClass:[UserFileListTableViewCell class] forCellReuseIdentifier:UserFileListItemTableViewCellID];
    
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
    UserFileListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:UserFileListItemTableViewCellID];
    CourseDetails* item = [self.courseDetailsWithParent.courseDetails.items objectAtIndex:indexPath.row];
//    cell.textLabel.text = item.course.title;
    cell.courseDetails = item;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseDetails* cd = [self.courseDetailsWithParent.courseDetails.items objectAtIndex:indexPath.row];
    if(cd.course.isDir.intValue == 1) {
        UserFileListViewController* c = [[UserFileListViewController alloc] init];
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
    [_tableView reloadData];
    if(courseDetailsWithParent.courseDetails.items.count == 0)
        [self setEmptyPageText:@"空文件夹"];
}

@end
