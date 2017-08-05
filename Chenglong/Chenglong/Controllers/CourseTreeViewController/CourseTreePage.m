//
//  CourseTreePage.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 7/26/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "CourseTreePage.h"
#import "RATableViewCell.h"

@interface CourseTreePage() <RATreeViewDelegate, RATreeViewDataSource>

@end

@implementation CourseTreePage

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    self.userSummaryView = [[UserSummaryView alloc] initWithFrame:CGRectMake(0, 0, [UIView screenWidth], UserSummaryViewHeight)];
    [self addSubview:self.userSummaryView];
    
    self.treeView = [[RATreeView alloc] initWithFrame:CGRectMake(0, self.userSummaryView.bottom, [UIView screenWidth], self.height - self.userSummaryView.bottom)];
    self.treeView.treeFooterView = [UIView new];
    self.treeView.separatorStyle = RATreeViewCellSeparatorStyleSingleLine;
    [self.treeView registerClass:[RATableViewCell class] forCellReuseIdentifier:NSStringFromClass([RATableViewCell class])];
    
    self.treeView.delegate = self;
    self.treeView.dataSource = self;
    
    self.refreshControl = [UIRefreshControl new];
    [self.treeView.scrollView addSubview:self.refreshControl];

    [self addSubview:self.treeView];
    
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    if(self.showUser) {
        self.userSummaryView.hidden = NO;
        self.treeView.height = self.height - self.userSummaryView.height;
        self.treeView.y = self.userSummaryView.bottom;
    }
    else {
        self.userSummaryView.hidden = YES;
        self.treeView.height = self.height;
        self.treeView.y = 0;
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


- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item
{
    CourseDetails *dataObject = item;
    
    NSInteger level = [self.treeView levelForCellForItem:item];
    NSInteger numberOfChildren = [dataObject.items count];
    NSString *detailText = [NSString localizedStringWithFormat:@"Number of children %@", [@(numberOfChildren) stringValue]];
    BOOL expanded = [self.treeView isCellForItemExpanded:item];
    
    RATableViewCell *cell = [self.treeView dequeueReusableCellWithIdentifier:NSStringFromClass([RATableViewCell class])];
    [cell setupWithTitle:dataObject.course.title detailText:detailText level:level additionButtonHidden:!expanded];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.courseDetails = item;
    
    if(!dataObject.course.isDir.integerValue) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
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
            [weakSelf.treeView collapseRowForItem:parent];
            [treeView selectRowForItem:parent animated:YES scrollPosition:RATreeViewScrollPositionNone];
        }
    };
    
    return cell;
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


-(void)setCourseDetails:(CourseDetails *)courseDetails {
    _courseDetails = courseDetails;
    [self.treeView reloadData];
}
@end
