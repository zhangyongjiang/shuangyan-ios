//
//  LoginView.h
//  Chenglong
//
//  Created by wangyaochang on 2016/12/25.
//  Copyright © 2016年 Chenglong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginView : UIView

@property (weak, nonatomic) IBOutlet UITextField *tfPhone;
@property (weak, nonatomic) IBOutlet UITextField *tfPwd;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnForgetPwd;

@end
