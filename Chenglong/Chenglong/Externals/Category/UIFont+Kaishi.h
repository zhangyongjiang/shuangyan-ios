//
//  UIFont+Kaishi.h
//  Kaishi
//
//  Created by Hyun Cho on 6/9/15.
//  Copyright (c) 2015 BCGDV. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIFontType) {
    UIFontTypeLight,
    UIFontTypeNormal,
    UIFontTypeHeavy,
};

@interface UIFont (Kaishi)

+ (UIFont*)type:(UIFontType)type size:(CGFloat)size;

@end

extern NSString* const kChineseFontNameLight;
extern NSString* const kChineseFontNameNormal;
extern NSString* const kChineseFontNameHeavy;

extern const CGFloat kDefaultLightFontLineMultiple;
extern const CGFloat kDefaultNormalFontLineMultiple;
extern const CGFloat kDefaultHeavyFontLineMultiple;