//
//  TotalFileHeaderView.m
//  Chenglong
//
//  Created by wangyaochang on 2017/1/4.
//  Copyright © 2017年 Chenglong. All rights reserved.
//

#import "TotalFileHeaderView.h"

@implementation TotalFileHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self layoutIfNeeded];
    
    _tfAge.layer.borderColor = [UIColor colorFromString:@"e6e6e6"].CGColor;
    _tfAge.layer.borderWidth = 1.0f;
    _tfAge.layer.cornerRadius = 5.f;
    _tfAge.layer.masksToBounds = YES;
    [_tfAge setLeftView:CGRectMake(0, 0, 24, 14) imageName:@"file_search_age_icon"];
    
    _tfKeyword.layer.borderColor = [UIColor colorFromString:@"e6e6e6"].CGColor;
    _tfKeyword.layer.borderWidth = 1.0f;
    _tfKeyword.layer.cornerRadius = 5.f;
    _tfKeyword.layer.masksToBounds = YES;
    [_tfKeyword setLeftView:CGRectMake(0, 0, 24, 14) imageName:@"file_search_keyword_icon"];
    
}

@end
