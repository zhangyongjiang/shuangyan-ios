//
//  NSString+Util.m
//  Kaishi
//
//  Created by wangyaochang on 16/7/5.
//  Copyright © 2016年 BCGDV. All rights reserved.
//

#import "NSString+Util.h"

@implementation NSString (Util)

+ (BOOL)isEmpty:(NSString *)aString{
    BOOL ret = NO;
    if ([aString isKindOfClass:[NSNull class]]) {
        ret = YES;
    }else if ((aString == nil) || ([[aString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0))
        ret = YES;
    return ret;
}

/**
 *  去除多余空格
 */
- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

/**
 * 返回字符串的 自定义 大小
 */
- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    CGSize textSize;
    if (CGSizeEqualToSize(size, CGSizeZero))
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        
        textSize = [self sizeWithAttributes:attributes];
    }
    else
    {
        NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        CGRect rect = [self boundingRectWithSize:size
                                         options:option
                                      attributes:attributes
                                         context:nil];
        
        textSize = rect.size;
    }
    return textSize;
}
/**
 *  判断密码是否有效
 *
 *  @return YES 符合 NO 不符合
 */
- (BOOL)kaishiJudgePwdCorrect
{
    NSString *str = @"^((?=.*[0-9].*)(?=.*[A-Za-z].*))[_0-9A-Za-z]{6,20}$";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    return [pre evaluateWithObject:self];
}

- (NSMutableAttributedString *)getAttributeStrWithDefalutDic:(NSDictionary *)defalutDic range:(NSRange)range changeDic:(NSDictionary *)changeDic
{
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:self attributes:defalutDic];
    if (changeDic != nil) {
        [att addAttributes:changeDic range:range];
    }
    return att;
}
/**
 *  返回重复字符的location
 *
 *  @param text     初始化的字符串
 *  @param findText 查找的字符
 *
 *  @return 返回重复字符的location
 */
- (NSMutableArray *)getRangeStr:(NSString *)findText
{
    if ([NSString isEmpty:findText]) {
        return nil;
    }
    NSMutableArray *arrayRanges = [NSMutableArray array];
    NSRange rang = [self rangeOfString:findText];
    if (rang.location != NSNotFound && rang.length != 0) {
        [arrayRanges addObject:NSStringFromRange(NSMakeRange(rang.location, findText.length))];
        NSRange rang1 = {0,0};
        NSInteger location = 0;
        NSInteger length = 0;
        for (int i = 0;; i++)
        {
            if (0 == i) {
                location = rang.location + rang.length;
                length = self.length - rang.location - rang.length;
                rang1 = NSMakeRange(location, length);
            }else
            {
                location = rang1.location + rang1.length;
                length = self.length - rang1.location - rang1.length;
                rang1 = NSMakeRange(location, length);
            }
            rang1 = [self rangeOfString:findText options:NSCaseInsensitiveSearch range:rang1];
            if (rang1.location == NSNotFound && rang1.length == 0) {
                break;
            }else
                [arrayRanges addObject:NSStringFromRange(NSMakeRange(rang1.location, findText.length))];
        }
        return arrayRanges;
    }
    return nil;
}

-(NSArray*)splitBy:(NSString *)str {
    return [self componentsSeparatedByString:str];
}

-(int)indexOf:(NSString *)substr {
    NSRange range = [self rangeOfString:substr];
    if (range.location == NSNotFound) {
        return -1;
    } else {
        return (int)range.location;
    }
}
@end
