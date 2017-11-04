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
#import "OnlineFileListViewController.h"
#import "MySearchController.h"
#import "CourseTreeViewController.h"
#import "MediaViewController.h"
#import "SearchBox.h"

#define OnlineFileListItemTableViewCellID @"OnlineSearchListItemTableViewCellID"

@interface OnlineFileListPage() <UITextFieldDelegate>
@end

@implementation OnlineSearchListPage

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [_tableView registerClass:[OnlineFileListTableViewCell class] forCellReuseIdentifier:OnlineFileListItemTableViewCellID];
    
    SearchBox* headView = [[SearchBox alloc] initWithFrame:CGRectMake(0, 0, UIView.screenWidth, 40)];
    headView.layer.borderWidth = 2;
    headView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _tableView.tableHeaderView = headView;

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
        CourseTreeViewController* c = [[CourseTreeViewController alloc] initWithUserId:cd.course.userId andCourseId:cd.course.id];
        
//        OnlineFileListViewController* c = [[OnlineFileListViewController alloc] init];
//        c.courseId = cd.course.id;
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPushController object:tableView userInfo:[NSDictionary  dictionaryWithObjectsAndKeys:c, @"controller",nil]];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPlayCourse object:cd userInfo:nil];
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
