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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CourseDetails* item = [self.courseDetailsList.items objectAtIndex:indexPath.row];
        [CourseApi CourseAPI_RemoveCourse:item.course.id onSuccess:^(Course *resp) {
            [self.courseDetailsList.items removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self save];
        } onError:^(APIError *err) {
            
        }];
    }
}

-(void)save {
    NSString* json = [self.courseDetailsList toJson];
    [json writeToFile:[self jsonFileName ] atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

-(NSString*)jsonFileName {
    NSString* fileName = [self.filePath stringByAppendingFormat:@"/%@.json", self.courseDetailsList.courseDetails.course.id];
    return fileName;
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
        c.courseId = cd.course.id;
        c.filePath = [self.filePath stringByAppendingFormat:@"/%@", cd.course.id];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPushController object:tableView userInfo:[NSDictionary  dictionaryWithObjectsAndKeys:c, @"controller",nil]];
    }
    else {
        FileDetailsViewController* c = [[FileDetailsViewController alloc] init];
        c.localCourseDetails = [[LocalCourseDetails alloc] init];
        c.localCourseDetails.courseDetails = cd;
        c.localCourseDetails.filePath = [self.filePath stringByAppendingFormat:@"/%@", cd.course.id];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPushController object:tableView userInfo:[NSDictionary  dictionaryWithObjectsAndKeys:c, @"controller",nil]];
    }
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
