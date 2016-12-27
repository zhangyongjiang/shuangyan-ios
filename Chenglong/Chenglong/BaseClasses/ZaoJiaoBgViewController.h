//
//  ZaoJiaoBgViewController.h
//  Chenglong
//
//  Created by wangyaochang on 2016/12/26.
//  Copyright © 2016年 Chenglong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZaoJiaoBgViewController : UIViewController

@property (nonatomic, strong) UIView *navBgView;
@property (nonatomic, strong) UIView *shadowLineView;

//显示错误信息等
- (void)alertShowWithMsg:(NSString *)msg;
@end
