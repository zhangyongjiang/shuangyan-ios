//
//  OnlineDirListPage.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "OnlineDirListPage.h"
#import "CoursePickerViewController.h"
#import "OnlineFileListTableViewCell.h"

#define OnlineDirListItemTableViewCellID @"OnlineDirListItemTableViewCellID"

@implementation OnlineDirListPage

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [_tableView registerClass:[OnlineFileListTableViewCell class] forCellReuseIdentifier:OnlineDirListItemTableViewCellID];
    
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
    OnlineFileListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:OnlineDirListItemTableViewCellID];
    CourseDetails* item = [self.courseDetailsList.items objectAtIndex:indexPath.row];
//    cell.textLabel.text = item.course.title;
    cell.courseDetails = item;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseDetails* cd = [self.courseDetailsList.items objectAtIndex:indexPath.row];
    CoursePickerViewController* c = [[CoursePickerViewController alloc] init];
    c.courseId = cd.course.id;
    c.delegate = self.delegate;
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPushController object:tableView userInfo:[NSDictionary  dictionaryWithObjectsAndKeys:c, @"controller",nil]];
}

-(void)setCourseDetailsList:(CourseDetailsList *)courseDetailsList {
    _courseDetailsList = courseDetailsList;
    [_tableView reloadData];
}

-(CourseDetails*)selected {
    NSIndexPath* path = [_tableView indexPathForSelectedRow];
    if(!path)
        return nil;
    return [self.courseDetailsList.items objectAtIndex:path.row];
}

@end
