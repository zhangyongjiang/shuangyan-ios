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

@end

@implementation CourseListPage

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 1;
//    self.layer.cornerRadius = 6;

    self.courseList = [NSMutableArray new];
    
    [_tableView registerClass:[CourseListTableViewCell class] forCellReuseIdentifier:CourseListItemTableViewCellID];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playStart:) name:NotificationPlayStart object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playNextNoti:) name:NotificationPlayNext object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playPrevNoti:) name:NotificationPlayPrev object:nil];

    return self;
}


-(void)playPrevNoti:(NSNotification*)noti
{
    if(self.courseList.count == 0)
        return;
    int section = _tableView.indexPathForSelectedRow.section;
    section --;
    if(section<0)
        section = self.courseList.count - 1;
    CourseDetails* cd = [self.courseList objectAtIndex:section];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationCourseReplay object:cd];
}

-(void)playNextNoti:(NSNotification*)noti
{
    if(self.courseList.count == 0)
        return;
    int section = _tableView.indexPathForSelectedRow.section;
    section ++;
    if(section>=self.courseList.count)
        section = 0;
    CourseDetails* cd = [self.courseList objectAtIndex:section];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationCourseReplay object:cd];
}

-(void)playStart:(NSNotification*)noti
{
    CourseDetails* cd = noti.object;
    Course* course = cd.course;
    [[NSUserDefaults standardUserDefaults] setObject:course.id forKey:CurrentPlayCourseId];
    for(int i=0; i<self.courseList.count; i++) {
        CourseDetails* cd = [self.courseList objectAtIndex:i];
        if ([cd.course.id isEqualToString:course.id]) {
            NSIndexPath* path = [NSIndexPath indexPathForRow:0 inSection:i];
            if([_tableView isVisible:path])
                [_tableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionNone];
            else
                [_tableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        }
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.courseList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
    CourseDetails* cd = [self.courseList objectAtIndex:section];
    return cd.course.resources.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CourseListItemTableViewCellID];
    CourseDetails* item = [self.courseList objectAtIndex:indexPath.section];
    cell.courseDetails = item;
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationCourseReplay object:[self.courseList objectAtIndex:indexPath.section]];
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
