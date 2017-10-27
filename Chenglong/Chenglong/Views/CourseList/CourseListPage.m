//
//  CourseListPage.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "CourseListPage.h"
#import "CourseListTableViewCell.h"

#define CourseListItemTableViewCellID @"CourseListItemTableViewCellID"

@interface CourseListPage()

@property(strong, nonatomic) NSMutableArray* courseList;

@end

@implementation CourseListPage

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.courseList = [NSMutableArray new];
    
    [_tableView registerClass:[CourseListTableViewCell class] forCellReuseIdentifier:CourseListItemTableViewCellID];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playStart:) name:NotificationPlayStart object:nil];

    return self;
}

-(void)playStart:(NSNotification*)noti
{
    PlayTask* task = noti.object;
    Course* course = task.localMediaContent.parent;
    for(int i=0; i<self.courseList.count; i++) {
        CourseDetails* cd = [self.courseList objectAtIndex:i];
        if ([cd.course.id isEqualToString:course.id]) {
            NSIndexPath* path = [NSIndexPath indexPathForRow:i inSection:0];
            [_tableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionTop];
        }
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.courseList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CourseListItemTableViewCellID];
    CourseDetails* item = [self.courseList objectAtIndex:indexPath.row];
    cell.courseDetails = item;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationCourseReplay object:[self.courseList objectAtIndex:indexPath.row]];
}

-(void)setCourseList:(NSMutableArray *)courseList
{
    _courseList = courseList;
    [_tableView reloadData];
}

-(void)addCourseDetailsList:(NSMutableArray *)courseDetailsList
{
    [self.courseList addObjectsFromArray:courseDetailsList];
    [_tableView reloadData];
}

-(void)addCourseDetails:(CourseDetails *)courseDetails
{
    [self.courseList addObject:courseDetails];
    [_tableView reloadData];
}

@end
