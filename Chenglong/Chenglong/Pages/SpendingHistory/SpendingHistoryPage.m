//
//  SpendingHistoryPage.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/27/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "SpendingHistoryPage.h"
#import "SpendingHistoryTableViewCell.h"

#define SpendingHistoryTableViewCellID @"SpendingHistoryTableViewCellID"

@implementation SpendingHistoryPage

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [_tableView registerClass:[SpendingHistoryTableViewCell class] forCellReuseIdentifier:SpendingHistoryTableViewCellID];
    
    return self;
}

-(void)setMoneyFlowList:(MoneyFlowList *)moneyFlowList {
    _moneyFlowList = moneyFlowList;
    [self reload];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.moneyFlowList.items.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self checkNextPageForTableView:tableView indexPath:indexPath];
    SpendingHistoryTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:SpendingHistoryTableViewCellID];
    MoneyFlow* item = [self.moneyFlowList.items objectAtIndex:indexPath.row];
    //    cell.textLabel.text = item.course.title;
    cell.moneyFlow = item;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MoneyFlow* cd = [self.moneyFlowList.items objectAtIndex:indexPath.row];
}

@end
