//
//  OrderItemView.m
//
//
//  Created by Kevin Zhang on 1/3/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

#import "SpendingHistoryItemView.h"

@interface SpendingHistoryItemView()

@property(strong, nonatomic) UIImageView* iconView;
@property(strong, nonatomic) FitLabel* label;

@end


@implementation SpendingHistoryItemView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.clipsToBounds = YES;
    self.layer.masksToBounds = YES;
    
    self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 32, 32)];
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.iconView];
    
    self.label = [[FitLabel alloc] init];
    self.label.x = 44;
    [self addSubview:self.label];

    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self.label vcenterInParent];
    [self.iconView vcenterInParent];
}

-(void)setMoneyFlow:(MoneyFlow *)moneyFlow {
    _moneyFlow = moneyFlow;
    self.label.text = [NSString stringWithFormat:@"%@ %@", [NSDate toYmdhm:moneyFlow.created], moneyFlow.forType];
}
@end
