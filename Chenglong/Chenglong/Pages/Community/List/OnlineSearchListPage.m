//
//  OnlineFileListPage.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "OnlineSearchListPage.h"
#import "OnlineSearchListViewController.h"
#import "OnlineFileListTableViewCell.h"
#import "WebViewController.h"
#import "OnlineFileDetailsViewController.h"

#define OnlineFileListItemTableViewCellID @"OnlineFileListItemTableViewCellID"

@implementation OnlineSearchListPage

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [_tableView registerClass:[OnlineFileListTableViewCell class] forCellReuseIdentifier:OnlineFileListItemTableViewCellID];
    
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    //    self.searchController.searchBar.showsCancelButton = NO;
    //    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.frame = CGRectMake(0, 0, [UIView screenWidth], 44);
    self.searchController.searchBar.placeholder = @"关键词";
    _tableView.tableHeaderView = self.searchController.searchBar;
    
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
    OnlineFileListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:OnlineFileListItemTableViewCellID];
    CourseDetails* item = [self.courseDetailsList.items objectAtIndex:indexPath.row];
//    cell.textLabel.text = item.course.title;
    cell.courseDetails = item;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseDetails* cd = [self.courseDetailsList.items objectAtIndex:indexPath.row];
    if(cd.course.isDir.intValue == 1) {
        OnlineSearchListViewController* c = [[OnlineSearchListViewController alloc] init];
        c.courseId = cd.course.id;
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPushController object:tableView userInfo:[NSDictionary  dictionaryWithObjectsAndKeys:c, @"controller",nil]];
    }
    else {
        OnlineFileDetailsViewController* c = [[OnlineFileDetailsViewController alloc] init];
        c.courseDetails = cd;
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPushController object:tableView userInfo:[NSDictionary  dictionaryWithObjectsAndKeys:c, @"controller",nil]];
    }
}

-(void)setCourseDetailsList:(CourseDetailsList *)courseDetailsList {
    _courseDetailsList = courseDetailsList;
    [_tableView reloadData];
}

-(void)appendCourseDetailsList:(CourseDetailsList *)next {
    [self.courseDetailsList.items addObjectsFromArray:next.items];
    [_tableView reloadData];
}

-(CourseDetails*)selected {
    NSIndexPath* path = [_tableView indexPathForSelectedRow];
    if(!path)
        return nil;
    return [self.courseDetailsList.items objectAtIndex:path.row];
}

@end
