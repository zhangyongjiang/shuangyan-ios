//
//  MyCourseTreePage.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 11/5/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "MyCourseTreePage.h"

@implementation MyCourseTreePage

-(UITableViewCellEditingStyle)treeView:(RATreeView *)treeView editingStyleForRowForItem:(nonnull id)item
{
    CourseDetails *cd = item;
    //    if(![cd isDirectory]) {
    //        return UITableViewCellEditingStyleNone;
    //    }
    return UITableViewCellEditingStyleDelete;
}

-(NSArray*)treeView:(RATreeView *)treeView editActionsForItem:(id)item
{
    CourseDetails *cd = item;
    NSMutableArray* array = [NSMutableArray new];
    if(![cd isDirectory]) {
        UITableViewRowAction *cleanCache = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除缓存" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                            {
                                                treeView.editing = NO;
                                                for (LocalMediaContent* mc in cd.course.resources) {
                                                    [mc deleteLocalFile];
                                                }
                                            }];
        cleanCache.backgroundColor = [UIColor lightGrayColor];
        [array addObject:cleanCache];
    }
    
    UITableViewRowAction *actRemove = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                       {
                                           treeView.editing = NO;
                                           [[NSNotificationCenter defaultCenter] postNotificationName:NotificationDeleteCourse object:item userInfo:nil];
                                       }];
    actRemove.backgroundColor = [UIColor redColor];
    [array addObject:actRemove];
    
    UITableViewRowAction *playNext = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"播放" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                      {
                                          treeView.editing = NO;
                                          [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPlayCourseAppend object:item userInfo:nil];
                                      }];
    playNext.backgroundColor = [UIColor blueColor];
    [array addObject:playNext];
    
    return array;
}

-(void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item
{
    CourseDetails *cd = item;
    if(![cd isDirectory]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPlayCourse object:cd userInfo:nil];
        
        //        MediaViewController* c = [MediaViewController new];
        //        c.courseDetails = cd;
        //        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPushController object:treeView userInfo:[NSDictionary  dictionaryWithObjectsAndKeys:c, @"controller",nil]];
    }
}

@end
