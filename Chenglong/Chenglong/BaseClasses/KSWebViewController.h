//
//  FKWebViewController.h
//  Kaishi
//
//  Created by jijunyuan on 16/7/11.
//  Copyright © 2016年 xinkaishi－jjy. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef void (^CloseBlock)(void);
@interface KSWebViewController : BaseViewController

@property (nonatomic, assign) BOOL isPush;
@property (nonatomic, strong) NSString * url;
@property (nonatomic, strong) NSString * navTitle;
@property (nonatomic, strong) CloseBlock closeBlock;
@property (nonatomic, assign) BOOL isLoadHeader;//M站商城 请求头部所用
@property (nonatomic, assign) BOOL isHiddenShare;//是否有分享功能

@end
