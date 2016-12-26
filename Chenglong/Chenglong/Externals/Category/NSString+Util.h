//
//  NSString+Util.h
//  Kaishi
//
//  Created by wangyaochang on 16/7/5.
//  Copyright © 2016年 BCGDV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Util)

/**
 *  @brief 是否为空
 *
 *  @param aString 需要判断的字符串
 *
 *  @return 是否为空
 */
+ (BOOL)isEmpty:(NSString*)aString;

/**
 *  去除多余空格
 */
- (NSString *)trim;
/**
 * 返回字符串的 自定义 大小
 */
- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

/**
 *  判断密码是否有效
 *
 *  @return YES 符合 NO 不符合
 */
- (BOOL)kaishiJudgePwdCorrect;

/**
 *  将普通string转换为 给特定range 加样式 的 attributeString
 *
 *  @param defalutDic 默认的样式dic
 *  @param range      需要特殊样式的range
 *  @param changeDic  特殊样式dic
 *
 *  @return attributeString
 */
- (NSMutableAttributedString *)getAttributeStrWithDefalutDic:(NSDictionary *)defalutDic range:(NSRange)range changeDic:(NSDictionary *)changeDic;

/**
 *  返回重复字符的range string
 *  @param findText 查找的字符
 *
 *  @return 返回重复字符的range的string
 */
- (NSMutableArray *)getRangeStr:(NSString *)findText;

-(NSArray*)splitBy:(NSString*)str;
-(int)indexOf:(NSString*)substr;
@end
