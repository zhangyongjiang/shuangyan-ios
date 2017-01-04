//
//  UITextField+Util.m
//  Chenglong
//
//  Created by wangyaochang on 2016/12/28.
//  Copyright © 2016年 Chenglong. All rights reserved.
//

#import "UITextField+Util.h"

@implementation UITextField (Util)

- (void)setLeftView:(CGRect)frame imageName:(NSString *)imgName
{
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    icon.frame = frame;
    icon.contentMode = UIViewContentModeCenter;
    self.leftView = icon;
    self.leftViewMode = UITextFieldViewModeAlways;
}

@end
