//
//  UINavigationBar+Awesome.h
//  business
//
//  Created by C.Maverick on 15/6/7.
//  Copyright (c) 2015年 C.Maverick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (Awesome)
- (void)cm_setBackgroundColor:(UIColor *)backgroundColor;
- (void)cm_setContentAlpha:(CGFloat)alpha;
- (void)cm_setShadowAlpha:(CGFloat)alpha;
- (void)cm_setTranslationY:(CGFloat)translationY;
- (void)cm_reset;
@end
