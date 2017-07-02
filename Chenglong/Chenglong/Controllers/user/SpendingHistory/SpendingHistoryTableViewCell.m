//
//  OrderItemTableViewCell.m
//
//
//  Created by Kevin Zhang on 1/3/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

#import "SpendingHistoryTableViewCell.h"

@interface SpendingHistoryTableViewCell()

@property(strong,nonatomic)SpendingHistoryItemView* view;

@end

@implementation SpendingHistoryTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.view = [[SpendingHistoryItemView alloc] initWithFrame:CGRectMake(0, 0, [UIView screenWidth], SpendingHistoryViewHeight)];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self.contentView addSubview:self.view];
    self.clipsToBounds = YES;
    return self;
}

-(void)setMoneyFlow:(MoneyFlow *)moneyFlow {
    _moneyFlow = moneyFlow;
    self.view.moneyFlow = moneyFlow;
}

@end
