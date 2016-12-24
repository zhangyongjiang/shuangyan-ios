//
//  NSObject+Tips.h
//  Foomoo
//
//  Created by QFish on 6/6/14.
//  Copyright (c) 2014 QFish.inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import <UIKit/UIKit.h>

#pragma mark - UIView

@interface UIView (Tips)

- (MBProgressHUD *)presentMessageTips:(NSString *)message;
- (MBProgressHUD *)presentSuccessTips:(NSString *)message;
- (MBProgressHUD *)presentFailureTips:(NSString *)message;
- (MBProgressHUD *)presentLoadingTips:(NSString *)message;
- (MBProgressHUD *)presentRightIconTips:(NSString *)message;

- (void)dismissTips;

@end

#pragma mark - UIViewController

@interface UIViewController (Tips)

- (MBProgressHUD *)presentMessageTips:(NSString *)message;
- (MBProgressHUD *)presentSuccessTips:(NSString *)message;
- (MBProgressHUD *)presentFailureTips:(NSString *)message;
- (MBProgressHUD *)presentLoadingTips:(NSString *)message;
- (MBProgressHUD *)presentFailureTipsWithYOffset:(NSString *)message;

- (void)dismissTips;

//显示对号加文字
- (MBProgressHUD *)presentRightIconTips:(NSString *)message;
@end
