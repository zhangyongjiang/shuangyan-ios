//
//  UIColor+Kaishi.m
//  Kaishi
//
//  Created by Hyun Cho on 6/9/15.
//  Copyright (c) 2015 BCGDV. All rights reserved.
//

#import "UIColor+Kaishi.h"

static NSString* const kCurrentThemeColor = @"CurrentThemeColor";
static UIColor* currentThemeColor = nil;

@implementation UIColor (Kaishi)

+ (UIColor*)colorFromHex:(NSUInteger)hex {
    return UIColorFromRGB(hex);
}


+ (UIColor*)colorFromString:(NSString*)string {
    if ( string.length == 0 ) {
        return [UIColor grayColor];
    }
    
    NSString* tempString = string;
    if ( [[string substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"#"] ) {
        tempString = [string substringFromIndex:1];
    }
    
    // http://stackoverflow.com/questions/6207329/how-to-set-hex-color-code-for-background
    NSString *cString = [[tempString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+ (UIImage *)colorImg:(UIColor*)color {
    CGSize imageSize = CGSizeMake(50.0, 50.0);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *colorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return colorImg;
}

+ (UIImage *)colorImg:(UIColor*)color size:(CGSize)size {
    CGSize imageSize = size;
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *colorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return colorImg;
}

+ (UIColor*)random {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}


+ (UIColor*)themeColor:(UIColorType)type {
    UIColor* color;
    if ( type == UIColorTypeLightText ) {
        color = [UIColor lightGrayColor];
    } else if ( type == UIColorTypeNormalText ) {
        color = [UIColor grayColor];
    } else if ( type == UIColorTypeDarkText ) {
        color = [UIColor darkGrayColor];        
    } else if ( type == UIColorTypePrimary ) {
        color = [UIColor kaishiColor:UIColorTypeThemeSelected];
    }
    
    return color;
}

+ (UIColor*)grayLevelColor:(UIColorGray)level {
    
    switch (level) {
        case UIColorGray1:
            return UIColorFromRGB(0xeef0f3);

        case UIColorGray2:
            return UIColorFromRGB(0xc6c8cd);
        
        case UIColorGray3:
            return UIColorFromRGB(0xbebebf);

        case UIColorGray4:
            return UIColorFromRGB(0x676d75);

        case UIColorGray5:
            return UIColorFromRGB(0x343333);
            
        case UIColorGray6:
            return UIColorFromRGB(0xb7ada5);

        default:
            break;
    }
}

/**
 *  不同位置的主色调
 */
+ (UIColor*)kaishiColor:(UIColorPostionType)type
{
    UIColor *color = [UIColor whiteColor];
    switch (type) {
        case UIColorTypeBarBackground:
            color = [UIColor whiteColor];
            break;
        case UIColorTypeBarTintColor:
            color = UIColorFromRGB(0x808080);
            break;
        case UIColorTypeBarTitleColor:
            color = UIColorFromRGB(0x9b9b9b);
            break;
        case UIColorTypeThemeSelected:
            color = UIColorFromRGB(0xdf1663);
            break;
        case UIColorTypeBackgroundColor:
            color = UIColorFromRGB(0xeeeeee);
            break;
        case UIColorTypeTableSeparateColor:
            color = UIColorFromRGB(0xdedede);
            break;
        default:
            color = [UIColor whiteColor];
            break;
    }
    return color;
}

@end
