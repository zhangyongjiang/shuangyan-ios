//
//  CourseTreePage.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 7/26/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "CourseTreePage.h"
#import "RATableViewCell.h"
#import "FileDetailsViewController.h"
#import "MediaViewController.h"

@interface CourseTreePage() <RATreeViewDelegate, RATreeViewDataSource>

@end

@implementation CourseTreePage

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);

    self.treeView = [[RATreeView alloc] initWithFrame:CGRectMake(0, 0, [UIView screenWidth], self.height)];
    self.treeView.treeFooterView = [UIView new];
    self.treeView.separatorStyle = RATreeViewCellSeparatorStyleNone;
    [self.treeView registerClass:[RATableViewCell class] forCellReuseIdentifier:NSStringFromClass([RATableViewCell class])];
    
    self.treeView.delegate = self;
    self.treeView.dataSource = self;
    
    self.refreshControl = [UIRefreshControl new];
    [self.treeView.scrollView addSubview:self.refreshControl];
    
    [self addSubview:self.treeView];
    [self.treeView autoPinEdgesToSuperviewMargins];
    
    return self;
}

-(CourseDetails*) getParentOfItem:(CourseDetails*) item
{
    return [self searchParent:self.courseDetails forItem:item];
}

-(CourseDetails*) searchParent:(CourseDetails*) parent forItem:(CourseDetails*) item
{
    for (CourseDetails* child in parent.items) {
        if([child.course.id isEqualToString:item.course.id])
            return parent;
        CourseDetails* found = [self searchParent:child forItem:item];
        if (found)
            return found;
    }
    return nil;
}

-(CourseDetails*) searchCourse:(NSString*)courseId inTree:(CourseDetails*) top
{
    if([courseId isEqualToString:top.course.id])
        return top;
    for (CourseDetails* child in top.items) {
        CourseDetails* found = [self searchCourse:courseId inTree:child];
        if(found != NULL)
            return found;
    }
    return NULL;
}


- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item
{
    CourseDetails *dataObject = item;
    
    NSInteger level = [self.treeView levelForCellForItem:item];
    BOOL expanded = [self.treeView isCellForItemExpanded:item];
    
    RATableViewCell *cell = [self.treeView dequeueReusableCellWithIdentifier:NSStringFromClass([RATableViewCell class])];
    [cell setupWithCourseDetails:dataObject level:level expanded:expanded];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    if(!dataObject.course.isDir.integerValue) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        //        UIButton *accessory = [UIButton buttonWithType:UIButtonTypeContactAdd];
        //        [cell setAccessoryView:accessory];
    }
    
    __weak typeof(self) weakSelf = self;
    cell.additionButtonTapAction = ^(id sender){
        //        if (![weakSelf.treeView isCellForItemExpanded:dataObject] || weakSelf.treeView.isEditing) {
        //            return;
        //        }
        //        CourseDetails *newDataObject = [[CourseDetails alloc] initWithName:@"Added value" children:@[]];
        //        [dataObject addChild:newDataObject];
        //        [weakSelf.treeView insertItemsAtIndexes:[NSIndexSet indexSetWithIndex:0] inParent:dataObject withAnimation:RATreeViewRowAnimationLeft];
        //        [weakSelf.treeView reloadRowsForItems:@[dataObject] withRowAnimation:RATreeViewRowAnimationNone];
    };
    
    cell.collapseButtonTapAction = ^(id sender) {
        CourseDetails* parent = [weakSelf getParentOfItem:dataObject];
        if(parent) {
            //            [weakSelf.treeView collapseRowForItem:parent];
            //            [treeView selectRowForItem:parent animated:YES scrollPosition:RATreeViewScrollPositionNone];
        }
    };
    
    return cell;
}

-(BOOL)treeView:(RATreeView *)treeView shouldExpandRowForItem:(id)item
{
    CourseDetails *data = item;
    RATableViewCell *cell = [treeView cellForItem:data];
    NSInteger level = [self.treeView levelForCellForItem:item];
    BOOL expanded = [self.treeView isCellForItemExpanded:item];
    [cell setupWithCourseDetails:data level:level expanded:YES];
    return YES;
}

-(BOOL)treeView:(RATreeView *)treeView shouldCollapaseRowForItem:(id)item
{
    CourseDetails *data = item;
    CourseDetails *parent = [self getParentOfItem:data];
    if(parent == NULL)
        return false;
    
    RATableViewCell *cell = [treeView cellForItem:data];
    NSInteger level = [self.treeView levelForCellForItem:item];
    BOOL expanded = [self.treeView isCellForItemExpanded:item];
    [cell setupWithCourseDetails:data level:level expanded:NO];
    return YES;
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [self.courseDetails.items count];
    }
    
    CourseDetails *data = item;
    return [data.items count];
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    CourseDetails *data = item;
    if (item == nil) {
        return [self.courseDetails.items objectAtIndex:index];
    }
    
    return data.items[index];
}

-(void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item
{
    CourseDetails *cd = item;
    CourseDetails* parent = [self getParentOfItem:item];
    cd.parent = parent;
    
    if(![cd isDirectory]) {
        //        FileDetailsViewController* c = [[FileDetailsViewController alloc] init];
        //        c.courseDetails = cd;
        //        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPushController object:treeView userInfo:[NSDictionary  dictionaryWithObjectsAndKeys:c, @"controller",nil]];
        MediaViewController* c = [MediaViewController new];
        c.courseDetails = cd;
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPushController object:treeView userInfo:[NSDictionary  dictionaryWithObjectsAndKeys:c, @"controller",nil]];
    }
}

-(void)setCourseDetails:(CourseDetails *)courseDetails {
    _courseDetails = courseDetails;
    CourseDetails* root = [courseDetails.items objectAtIndex:0];
    [self.treeView reloadData];
    [self.treeView expandRowForItem:root];
}

-(void)selectCourse:(NSString *)courseId
{
    if(courseId == NULL)
        return;
    CourseDetails* item = [self searchCourse:courseId inTree:self.courseDetails];
    if(item == NULL)
        return;
    CourseDetails* parent = [self getParentOfItem:item];
    [self expandItem:parent];
    [self.treeView expandRowForItem:item];
    [self.treeView selectRowForItem:item animated:YES scrollPosition:RATreeViewScrollPositionMiddle];
}

-(void)expandItem:(CourseDetails*)item
{
    CourseDetails* parent = [self getParentOfItem:item];
    if(parent != NULL) {
        [self expandItem:parent];
    }
    [self.treeView expandRowForItem:item];
}

- (void)treeView:(RATreeView *)treeView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowForItem:(id)item
{
    if (editingStyle != UITableViewCellEditingStyleDelete) {
        return;
    }
}

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
    if(![cd isDirectory]) {
        UITableViewRowAction *button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除缓存" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                        {
                                            treeView.editing = NO;
                                            for (LocalMediaContent* mc in cd.course.resources) {
                                                [mc deleteLocalFile];
                                            }
                                        }];
        button.backgroundColor = [UIColor lightGrayColor]; //arbitrary color
        
        return @[button];
    }
    
    UITableViewRowAction *button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Play" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                    {
                                        treeView.editing = NO;
                                        MediaViewController* c = [MediaViewController new];
                                        c.courseDetails = item;
                                        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPushController object:treeView userInfo:[NSDictionary  dictionaryWithObjectsAndKeys:c, @"controller",nil]];
                                    }];
    button.backgroundColor = [UIColor lightGrayColor]; //arbitrary color
    UITableViewRowAction *button2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                     {
                                         treeView.editing = NO;
                                     }];
    button2.backgroundColor = [UIColor redColor]; //arbitrary color
    
    return @[button, button2];
}

-(CourseDetails*)deleteCourse:(NSString *)courseId
{
    CourseDetails* item = [self searchCourse:courseId inTree:self.courseDetails];
    if(item == NULL)
        return NULL;
    CourseDetails* parent = [self getParentOfItem:item];
    for (int i=0; i<parent.items.count; i++) {
        CourseDetails* c = [parent.items objectAtIndex:i];
        if([c.course.id isEqualToString:courseId]) {
            [parent.items removeObjectAtIndex:i];
            [self.treeView reloadData];
            [self expandItem:parent];
            break;
        }
    }
    return parent;
}
@end
