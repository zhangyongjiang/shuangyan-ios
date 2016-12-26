//
//  UIFont+Kaishi.m
//  Kaishi
//
//  Created by Hyun Cho on 6/9/15.
//  Copyright (c) 2015 BCGDV. All rights reserved.
//

#import "UIFont+Kaishi.h"

NSString* const kChineseFontNameLight = @"STHeitiSC-Light"; // system font
NSString* const kChineseFontNameNormal = @"STHeitiSC-Medium"; // system font
NSString* const kChineseFontNameHeavy = @"FZLTTHK--GBK1-0"; // LantingheiSCHeavy.ttf font

const CGFloat kDefaultLightFontLineMultiple = 1.4;
const CGFloat kDefaultNormalFontLineMultiple = 1.4;
const CGFloat kDefaultHeavyFontLineMultiple = 1.0;

@implementation UIFont (Kaishi)

+ (UIFont*)type:(UIFontType)type size:(CGFloat)size {
    
    UIFont* font;
    if ( type == UIFontTypeLight ) {
        font = [UIFont fontWithName:kChineseFontNameLight size:size];
    } else if ( type == UIFontTypeNormal ) {
        font = [UIFont fontWithName:kChineseFontNameNormal size:size];
    } else if ( type == UIFontTypeHeavy ) {
        font = [UIFont fontWithName:kChineseFontNameHeavy size:size];
    } else {
        NSAssert(false, @"Unsupported Font Type");
        font = [UIFont systemFontOfSize:10];
    }
    
    return font;
}


@end
