//
//  OrderItemView.m
//
//
//  Created by Kevin Zhang on 1/3/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

#import "SpendingHistoryItemView.h"

@interface SpendingHistoryItemView()

@property(strong, nonatomic) FitLabel* label;

@end


@implementation SpendingHistoryItemView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.clipsToBounds = YES;
    self.layer.masksToBounds = YES;
    
    self.label = [[FitLabel alloc] init];
    self.label.x = Margin;
    [self addSubview:self.label];

    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self.label vcenterInParent];
}

-(void)setMoneyFlow:(MoneyFlow *)moneyFlow {
    _moneyFlow = moneyFlow;
    self.label.font = [UIFont fontWithName:@"STHeitiSC-Light" size:10.];
    self.label.text = [NSString stringWithFormat:@"%@ %i bytes, 余额%@", [NSDate toYmdhm:moneyFlow.created], -moneyFlow.value.intValue, moneyFlow.balance];
}
@end
