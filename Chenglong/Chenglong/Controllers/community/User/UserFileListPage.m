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
#import "OnlineFileListViewController.h"

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
    return self.courseDetailsList.items.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self checkNextPageForTableView:tableView indexPath:indexPath];
    UserFileListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:UserFileListItemTableViewCellID];
    CourseDetails* item = [self.courseDetailsList.items objectAtIndex:indexPath.row];
//    cell.textLabel.text = item.course.title;
    cell.courseDetails = item;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseDetails* cd = [self.courseDetailsList.items objectAtIndex:indexPath.row];
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

-(void)setCourseDetailsList:(CourseDetailsList *)courseDetailsList {
    _courseDetailsList = courseDetailsList;
    [_tableView reloadData];
    if(courseDetailsList.items.count == 0)
        [self setEmptyPageText:@"空文件夹"];
}

@end
