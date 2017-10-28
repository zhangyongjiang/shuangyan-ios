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

@property(strong, nonatomic) UIButton* btnPlayNow;
@property(strong, nonatomic) UIButton* btnPlayNext;

@end

@implementation CourseTreePage

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
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
    
    self.btnPlayNow = [UIButton new];
    [self.btnPlayNow setImage:[UIImage imageNamed:@"ic_play_arrow"] forState:UIControlStateNormal];
    self.btnPlayNow.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    self.btnPlayNow.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
    [self addSubview:self.btnPlayNow];
    [self.btnPlayNow autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.btnPlayNow autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [self.btnPlayNow autoSetDimensionsToSize:CGSizeMake(80, 40)];
    [self.btnPlayNow addTarget:self action:@selector(playNow:) forControlEvents:UIControlEventTouchUpInside];
    self.btnPlayNow.hidden = YES;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(courseSelected:) name:NotificationCourseSelected object:nil];
    
    return self;
}

-(void)playNow:(id)sender
{
    NSMutableArray* selected = [self getSelectedCourses];
    if(selected.count == 0)
        return;
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPlayCourseList object:selected userInfo:nil];
}

-(void)courseSelected:(NSNotification*)noti
{
    CourseDetails* cd = noti.object;
    CourseDetails* item = [self searchCourse:cd.course.id inTree:self.courseDetails];
    if(cd.course.id == NULL)
        item = [self.courseDetails.items objectAtIndex:0];
    if(item == NULL)
        return;
    [self markSelected:item selected:cd.selected];
    CourseDetails* parent = [self getParentOfItem:item];
    if(parent) {
        if(!cd.selected && parent.selected) {
            parent.selected = NO;
            RATableViewCell *cell = [self.treeView cellForItem:parent];
            if(!cell.isHidden) {
                NSInteger level = [self.treeView levelForCellForItem:parent];
                BOOL expanded = [self.treeView isCellForItemExpanded:parent];
                [cell setupWithCourseDetails:parent level:level expanded:expanded];
            }
        }
        else if(cd.selected && !parent.selected) {
            BOOL allSelected = YES;
            for (CourseDetails* child in parent.items) {
                if(!child.selected) {
                    allSelected = NO;
                    break;
                }
            }
            if(allSelected) {
                parent.selected = YES;
                RATableViewCell *cell = [self.treeView cellForItem:parent];
                if(!cell.isHidden) {
                    NSInteger level = [self.treeView levelForCellForItem:parent];
                    BOOL expanded = [self.treeView isCellForItemExpanded:parent];
                    [cell setupWithCourseDetails:parent level:level expanded:expanded];
                }
            }
        }
    }
    [self setPlayButton];
}

-(void)setPlayButton
{
    // disable the play button for now.
    return;
    
    NSMutableArray* selected = [self getSelectedCourses];
    if(selected.count == 0) {
        self.btnPlayNow.hidden = YES;
        self.btnPlayNext.hidden = YES;
    }
    else {
        self.btnPlayNow.hidden = NO;
        self.btnPlayNext.hidden = NO;
        NSString* title = [NSString stringWithFormat:@"%d", selected.count];
        [self.btnPlayNow setTitle:title forState:UIControlStateNormal];
    }
}

-(NSMutableArray*)getSelectedCourses {
    NSMutableArray* selectedCourses =[NSMutableArray new];
    [self addSelectedCourses:selectedCourses inCourseDetails:self.courseDetails];
    return selectedCourses;
}
-(void)addSelectedCourses:(NSMutableArray*)selected inCourseDetails:(CourseDetails*)cd {
    if(cd.items.count==0 && !cd.course.isDir.integerValue) {
        if(cd.selected)
           [selected addObject:cd];
        return;
    }
    for (CourseDetails* child in cd.items) {
        [self addSelectedCourses:selected inCourseDetails:child];
    }
}

-(void)markSelected:(CourseDetails*)cd selected:(BOOL)selected {
    cd.selected = selected;
    RATableViewCell *cell = [self.treeView cellForItem:cd];
    if(!cell.isHidden) {
        NSInteger level = [self.treeView levelForCellForItem:cd];
        BOOL expanded = [self.treeView isCellForItemExpanded:cd];
        [cell setupWithCourseDetails:cd level:level expanded:expanded];
    }

    if(cd.course.isDir.integerValue) {
        for (CourseDetails* child in cd.items) {
            [self markSelected:child selected:selected];
        }
    }
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
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
//    UIButton *accessory = [UIButton buttonWithType:UIButtonTypeContactAdd];
//    [cell setAccessoryView:accessory];

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
//        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationCourseSelected object:cd userInfo:nil];
        
//        MediaViewController* c = [MediaViewController new];
//        c.courseDetails = cd;
//        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPushController object:treeView userInfo:[NSDictionary  dictionaryWithObjectsAndKeys:c, @"controller",nil]];
    }
}

-(void)setParent:(CourseDetails*)cd {
    for(CourseDetails* child in cd.items) {
        child.parent = cd;
        [self setParent:child];
    }
}

-(void)setCourseDetails:(CourseDetails *)courseDetails {
    [self setParent:courseDetails];
    _courseDetails = courseDetails;
    CourseDetails* root = [courseDetails.items objectAtIndex:0];
    self.btnPlayNow.hidden = YES;
    self.btnPlayNext.hidden = YES;
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
                                        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPlayCourse object:item userInfo:nil];
//                                        MediaViewController* c = [MediaViewController new];
//                                        c.courseDetails = item;
//                                        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPushController object:treeView userInfo:[NSDictionary  dictionaryWithObjectsAndKeys:c, @"controller",nil]];
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
    int selected = 0;
    for (int i=parent.items.count-1; i>=0; i--) {
        CourseDetails* c = [parent.items objectAtIndex:i];
        if([c.course.id isEqualToString:courseId]) {
            [parent.items removeObjectAtIndex:i];
            [self.treeView reloadData];
            [self expandItem:parent];
        }
        else {
            if (c.selected)
                selected++;
        }
    }
    if(selected == parent.items.count) {
        if(!parent.selected) {
            parent.selected = YES;
            RATableViewCell *cell = [self.treeView cellForItem:parent];
            if(!cell.isHidden) {
                NSInteger level = [self.treeView levelForCellForItem:parent];
                BOOL expanded = [self.treeView isCellForItemExpanded:parent];
                [cell setupWithCourseDetails:parent level:level expanded:expanded];
            }
        }
    }
    if(!item.selected) {
        [self setPlayButton];
    }
    return parent;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.frame = self.superview.bounds;
}
@end
