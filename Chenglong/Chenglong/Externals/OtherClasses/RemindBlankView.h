//
//  RemindBlankView.h
//  Kaishi
//
//  Created by wangyaochang on 16/9/2.
//  Copyright © 2016年 BCGDV. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BtnBlankTapBlock)(void);

@interface RemindBlankView : UIView

@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, copy) BtnBlankTapBlock tapBlock;

+ (RemindBlankView *)loadWithImgTopValue:(CGFloat)value message:(NSString *)msg image:(UIImage *)img;

- (void)setupBtnShow:(BOOL)isShow title:(NSString *)title tap:(BtnBlankTapBlock)tapBlock;
@end
