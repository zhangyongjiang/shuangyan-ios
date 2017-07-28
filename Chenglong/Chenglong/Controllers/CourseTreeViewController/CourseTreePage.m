//
//  CourseTreePage.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 7/26/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "CourseTreePage.h"
#import "RADataObject.h"
#import "RATableViewCell.h"

@interface CourseTreePage() <RATreeViewDelegate, RATreeViewDataSource>

@property (strong, nonatomic) NSArray *data;

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
    
    [self addSubview:self.treeView];
    
    [self loadData];
    [self.treeView reloadData];
    
    return self;
}

//-(void)layoutSubviews {
//    [super layoutSubviews];
//    if(self.showUser) {
//        self.userSummaryView.hidden = NO;
//        self.treeView.height = self.height - self.userSummaryView.height;
//    }
//    else {
//        self.userSummaryView.hidden = YES;
//        self.treeView.height = self.height;
//    }
//}


- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item
{
    RADataObject *dataObject = item;
    
    NSInteger level = [self.treeView levelForCellForItem:item];
    NSInteger numberOfChildren = [dataObject.children count];
    NSString *detailText = [NSString localizedStringWithFormat:@"Number of children %@", [@(numberOfChildren) stringValue]];
    BOOL expanded = [self.treeView isCellForItemExpanded:item];
    
    RATableViewCell *cell = [self.treeView dequeueReusableCellWithIdentifier:NSStringFromClass([RATableViewCell class])];
    [cell setupWithTitle:dataObject.name detailText:detailText level:level additionButtonHidden:!expanded];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    __weak typeof(self) weakSelf = self;
    cell.additionButtonTapAction = ^(id sender){
        if (![weakSelf.treeView isCellForItemExpanded:dataObject] || weakSelf.treeView.isEditing) {
            return;
        }
        RADataObject *newDataObject = [[RADataObject alloc] initWithName:@"Added value" children:@[]];
        [dataObject addChild:newDataObject];
        [weakSelf.treeView insertItemsAtIndexes:[NSIndexSet indexSetWithIndex:0] inParent:dataObject withAnimation:RATreeViewRowAnimationLeft];
        [weakSelf.treeView reloadRowsForItems:@[dataObject] withRowAnimation:RATreeViewRowAnimationNone];
    };
    
    return cell;
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [self.data count];
    }
    
    RADataObject *data = item;
    return [data.children count];
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    RADataObject *data = item;
    if (item == nil) {
        return [self.data objectAtIndex:index];
    }
    
    return data.children[index];
}


- (void)loadData
{
    RADataObject *phone1 = [RADataObject dataObjectWithName:@"Phone 1" children:nil];
    RADataObject *phone2 = [RADataObject dataObjectWithName:@"Phone 2" children:nil];
    RADataObject *phone3 = [RADataObject dataObjectWithName:@"Phone 3" children:nil];
    RADataObject *phone4 = [RADataObject dataObjectWithName:@"Phone 4" children:nil];
    
    RADataObject *phone = [RADataObject dataObjectWithName:@"Phones"
                                                  children:[NSArray arrayWithObjects:phone1, phone2, phone3, phone4, nil]];
    
    RADataObject *notebook1 = [RADataObject dataObjectWithName:@"Notebook 1" children:nil];
    RADataObject *notebook2 = [RADataObject dataObjectWithName:@"Notebook 2" children:nil];
    
    RADataObject *computer1 = [RADataObject dataObjectWithName:@"Computer 1"
                                                      children:[NSArray arrayWithObjects:notebook1, notebook2, nil]];
    RADataObject *computer2 = [RADataObject dataObjectWithName:@"Computer 2" children:nil];
    RADataObject *computer3 = [RADataObject dataObjectWithName:@"Computer 3" children:nil];
    
    RADataObject *computer = [RADataObject dataObjectWithName:@"Computers"
                                                     children:[NSArray arrayWithObjects:computer1, computer2, computer3, nil]];
    RADataObject *car = [RADataObject dataObjectWithName:@"Cars" children:nil];
    RADataObject *bike = [RADataObject dataObjectWithName:@"Bikes" children:nil];
    RADataObject *house = [RADataObject dataObjectWithName:@"Houses" children:nil];
    RADataObject *flats = [RADataObject dataObjectWithName:@"Flats" children:nil];
    RADataObject *motorbike = [RADataObject dataObjectWithName:@"Motorbikes" children:nil];
    RADataObject *drinks = [RADataObject dataObjectWithName:@"Drinks" children:nil];
    RADataObject *food = [RADataObject dataObjectWithName:@"Food" children:nil];
    RADataObject *sweets = [RADataObject dataObjectWithName:@"Sweets" children:nil];
    RADataObject *watches = [RADataObject dataObjectWithName:@"Watches" children:nil];
    RADataObject *walls = [RADataObject dataObjectWithName:@"Walls" children:nil];
    
    self.data = [NSArray arrayWithObjects:phone, computer, car, bike, house, flats, motorbike, drinks, food, sweets, watches, walls, nil];
    
}

-(void)setCourseDetails:(CourseDetails *)courseDetails {
    _courseDetails = courseDetails;
    [self.treeView reloadData];
}
@end
