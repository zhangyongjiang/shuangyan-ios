//
//  ResetPwdView.m
//  Chenglong
//
//  Created by wangyaochang on 2016/12/28.
//  Copyright © 2016年 Chenglong. All rights reserved.
//

#import "ResetPwdView.h"

@interface ResetPwdView ()

@property (nonatomic, strong) SecondCountdown *secondCountDown;
@end

@implementation ResetPwdView

-(void)dealloc
{
    if (self.secondCountDown) {
        [self.secondCountDown stop];
        self.secondCountDown = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupSubViews];
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

- (void)setupSubViews
{
    UIImageView *phontIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_phone_icon"]];
    phontIcon.frame = CGRectMake(0, 0, 26, 16);
    phontIcon.contentMode = UIViewContentModeLeft;
    _tfPhone.leftView = phontIcon;
    _tfPhone.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *pwdIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_pwd_icon"]];
    pwdIcon.frame = CGRectMake(0, 0, 26, 16);
    pwdIcon.contentMode = UIViewContentModeLeft;
    _tfPwd.leftView = pwdIcon;
    _tfPwd.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *codeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_icon_code"]];
    codeIcon.frame = CGRectMake(0, 0, 26, 16);
    codeIcon.contentMode = UIViewContentModeLeft;
    _tfCode.leftView = codeIcon;
    _tfCode.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *nameIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_pwd_icon"]];
    nameIcon.frame = CGRectMake(0, 0, 26, 16);
    nameIcon.contentMode = UIViewContentModeLeft;
    _tfAgainPwd.leftView = nameIcon;
    _tfAgainPwd.leftViewMode = UITextFieldViewModeAlways;
    
    [_btnSendCode setTitleColor:[UIColor kaishiColor:UIColorTypeThemeSelected] forState:UIControlStateNormal];
    [_btnSendCode setTitleColor:[UIColor colorFromString:@"c6c8cd"] forState:UIControlStateDisabled];
    
}

- (IBAction)sendCodeEvent:(id)sender
{
    
    //    PhoneValidationRequest* validationRequest = [[PhoneValidationRequest alloc] init];
    //    validationRequest.phone = [Global loggedInUser].privateInfo.phone;
    WeakSelf(weakSelf)
    [SVProgressHUD show];
    
    //    [KaishiApi UserAPI_SendPhoneValidationCode:validationRequest onSuccess:^(GenericResponse *resp) {
    [SVProgressHUD dismiss];
    
    self.btnSendCode.enabled = NO;
    [weakSelf.btnSendCode setTitle:[NSString stringWithFormat:@"%ld秒后重发",max_second] forState:UIControlStateNormal];
    
    if (weakSelf.secondCountDown) {
        [weakSelf.secondCountDown stop];
        weakSelf.secondCountDown = nil;
    }
    
    weakSelf.secondCountDown = [SecondCountdown CountdownWithMaxSecond:max_second];
    weakSelf.secondCountDown.secondDidchanged = ^(NSInteger changeSecond){
        [weakSelf.btnSendCode setTitle:[NSString stringWithFormat:@"%ld秒后重发",changeSecond] forState:UIControlStateNormal];
    };
    weakSelf.secondCountDown.secondDidFinished = ^(NSInteger changeSecond){
        weakSelf.btnSendCode.enabled = YES;
        [weakSelf.btnSendCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        weakSelf.secondCountDown = nil;
    };
    
    //    } onError:^(APIError *err) {
    //        [SVProgressHUD dismiss];
    //        ALERT_VIEW_WITH_TITLE(err.errorCode, err.errorMsg);
    //    }];
}


@end
