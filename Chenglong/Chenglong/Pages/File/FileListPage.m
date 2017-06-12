//
//  FileListPage.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "FileListPage.h"
#import "FileListViewController.h"
#import "FileListTableViewCell.h"
#import "WebViewController.h"
#import "FileDetailsViewController.h"

#define FileListItemTableViewCellID @"FileListItemTableViewCellID"

@implementation FileListPage

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [_tableView registerClass:[FileListTableViewCell class] forCellReuseIdentifier:FileListItemTableViewCellID];
    
    return self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.courseDetailsList.items.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FileListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:FileListItemTableViewCellID];
    CourseDetails* item = [self.courseDetailsList.items objectAtIndex:indexPath.row];
//    cell.textLabel.text = item.course.title;
    cell.courseDetails = item;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseDetails* cd = [self.courseDetailsList.items objectAtIndex:indexPath.row];
    if(cd.course.isDir.intValue == 1) {
        FileListViewController* c = [[FileListViewController alloc] init];
        c.currentCourseId = cd.course.id;
        c.currentDirPath = [self.currentDirPath stringByAppendingFormat:@"/%@", cd.course.id];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPushController object:tableView userInfo:[NSDictionary  dictionaryWithObjectsAndKeys:c, @"controller",nil]];
    }
    else {
        FileDetailsViewController* c = [[FileDetailsViewController alloc] init];
        c.localCourseDetails = [[LocalCourseDetails alloc] init];
        c.localCourseDetails.courseDetails = cd;
        c.localCourseDetails.filePath = [self.currentDirPath stringByAppendingFormat:@"/%@", cd.course.id];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPushController object:tableView userInfo:[NSDictionary  dictionaryWithObjectsAndKeys:c, @"controller",nil]];
    }
}

-(void)setCourseDetailsList:(CourseDetailsList *)courseDetailsList {
    _courseDetailsList = courseDetailsList;
    [_tableView reloadData];
}
@end
