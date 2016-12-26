//
//  LoginView.m
//  Chenglong
//
//  Created by wangyaochang on 2016/12/25.
//  Copyright © 2016年 Chenglong. All rights reserved.
//

#import "LoginView.h"

@interface LoginView ()

@property (weak, nonatomic) IBOutlet UIView *headerBgView1;
@property (weak, nonatomic) IBOutlet UIView *headerBgView2;
@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UITextField *tfPhone;
@property (weak, nonatomic) IBOutlet UITextField *tfPwd;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnForgetPwd;


@end

@implementation LoginView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self layoutIfNeeded];
    [self configSubView];
}

- (void)configSubView
{
    _headerBgView1.layer.cornerRadius = CGRectGetHeight(_headerBgView1.bounds)/2;
    _headerBgView1.layer.masksToBounds = YES;
    _headerBgView2.layer.cornerRadius = CGRectGetHeight(_headerBgView2.bounds)/2;
    _headerBgView2.layer.masksToBounds = YES;
    _headerView.layer.cornerRadius = CGRectGetHeight(_headerView.bounds)/2;
    _headerView.layer.masksToBounds = YES;
    
    _tfPhone.leftViewMode = UITextFieldViewModeAlways;
    _tfPwd.leftViewMode = UITextFieldViewModeAlways;
    _tfPhone.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_phone_icon"]];
    _tfPwd.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_pwd_icon"]];
    
}

@end
