//
//  UIViewController+BackButtonAction.m
//  Fadein
//
//  Created by jijunyuan on 15/5/21.
//  Copyright (c) 2015年 Arceus. All rights reserved.
//

#import "UIViewController+BackButtonAction.h"

@implementation UIViewController (BackButtonAction)
//使用的时候 重写此方法
-(BOOL)navigationShouldPopOnBackButton
{
    return YES;
}
@end
