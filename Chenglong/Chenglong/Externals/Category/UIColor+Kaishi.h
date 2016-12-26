//
//  UIColor+Kaishi.h
//  Kaishi
//
//  Created by Hyun Cho on 6/9/15.
//  Copyright (c) 2015 BCGDV. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBA(rgbaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF000000) >> 32))/255.0 green:((float)((rgbValue & 0xFF0000) >> 16))/255.0 blue:((float)((rgbValue & 0xFF00) >> 8))/255.0 alpha:((float)(rgbValue & 0xFF))/255.0]

typedef NS_ENUM(NSInteger, UIColorType) {
    UIColorTypePrimary,
    UIColorTypeLightText,
    UIColorTypeNormalText,
    UIColorTypeDarkText,
    UIColorTypeDarkCount,
};


typedef NS_ENUM(NSInteger, UIColorGray) {
    UIColorGray1, // near white
    UIColorGray2,
    UIColorGray3,
    UIColorGray4,
    UIColorGray5, // near black
    UIColorGray6, // NEW gray
};

/**
 *  不同位置view的颜色
 */
typedef NS_ENUM(NSInteger, UIColorPostionType) {
    /**
     *  导航背景色
     */
    UIColorTypeBarBackground,
    /**
     *  导航tintColor
     */
    UIColorTypeBarTintColor,
    /**
     *  导航titleColor
     */
    UIColorTypeBarTitleColor,
    /**
     *  主色调 选中颜色
     */
    UIColorTypeThemeSelected,
    /**
     *  主色调 controller 背景颜色
     */
    UIColorTypeBackgroundColor,
    /**
     *  table分割线
     */
    UIColorTypeTableSeparateColor
};

@interface UIColor (Kaishi)

+ (UIColor*)colorFromHex:(NSUInteger)hex;
+ (UIColor*)colorFromString:(NSString*)string;
+ (UIImage *)colorImg:(UIColor*)color;
+ (UIImage *)colorImg:(UIColor*)color size:(CGSize)size;

+ (UIColor*)random;
+ (UIColor*)grayLevelColor:(UIColorGray)level;

// theme related
+ (UIColor*)themeColor:(UIColorType)type;

/**
 *  不同位置的主色调
 */
+ (UIColor*)kaishiColor:(UIColorPostionType)type;


@end
