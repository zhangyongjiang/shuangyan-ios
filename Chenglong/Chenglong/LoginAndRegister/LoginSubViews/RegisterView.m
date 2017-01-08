//
//  RegisterView.m
//  Chenglong
//
//  Created by wangyaochang on 2016/12/27.
//  Copyright © 2016年 Chenglong. All rights reserved.
//

#import "RegisterView.h"

@interface RegisterView ()<TTTAttributedLabelDelegate>

@property (nonatomic, strong) SecondCountdown *secondCountDown;
@end

@implementation RegisterView

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
    self.lbRemind.font = [UIFont systemFontOfSize:11.f];
    
    [self setupSubViews];
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

- (void)setupSubViews
{
    CGRect frame = CGRectMake(0, 0, 26, 16);
    [_tfPhone setLeftView:frame imageName:@"login_phone_icon"];
    [_tfPwd setLeftView:frame imageName:@"login_pwd_icon"];
    [_tfCode setLeftView:frame imageName:@"register_icon_code"];
    [_tfNickName setLeftView:frame imageName:@"register_icon_name"];
    
    [_btnSendCode setTitleColor:[UIColor kaishiColor:UIColorTypeThemeSelected] forState:UIControlStateNormal];
    [_btnSendCode setTitleColor:[UIColor colorFromString:@"c6c8cd"] forState:UIControlStateDisabled];
    
    NSString * tipText = @"注册代表您同意《用户服务协议》";
    NSString * colorText = @"《用户服务协议》";
    NSRange rangePrive = [tipText rangeOfString:colorText];
    [self.lbRemind setText:tipText afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        [mutableAttributedString setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorFromString:@"1a1a1a"],kCTForegroundColorAttributeName, nil] range:NSMakeRange(0, mutableAttributedString.length)];
        NSMutableDictionary *mutableLinkAttributes = [NSMutableDictionary dictionary];
        [mutableLinkAttributes setObject:[UIFont systemFontOfSize:11.f] forKey:(NSString *)kCTFontAttributeName];
        [mutableLinkAttributes setObject:(__bridge id)[[UIColor kaishiColor:UIColorTypeThemeSelected] CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
        [mutableAttributedString addAttributes:mutableLinkAttributes range:rangePrive];
        return mutableAttributedString;
    }];
    self.lbRemind.delegate = self;
    self.lbRemind.linkAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithBool:NO],(NSString *)kCTUnderlineStyleAttributeName,nil];
    //点击后的颜色
    self.lbRemind.activeLinkAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1],(NSString *)kCTForegroundColorAttributeName,nil];
    
    [self.lbRemind addLinkToURL:[NSURL URLWithString:@"privite"] withRange:rangePrive];
}

- (IBAction)sendCodeEvent:(id)sender
{
    
    PhoneRegisterRequest* validationRequest = [[PhoneRegisterRequest alloc] init];
    validationRequest.phone = [Global loggedInUser].phone;
    WeakSelf(weakSelf)
    [SVProgressHUD show];
    
    [UserApi UserAPI_SendPhoneValidationCode:validationRequest onSuccess:^(User *resp) {
        
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
    } onError:^(APIError *err) {
        [SVProgressHUD dismiss];
        ALERT_VIEW_WITH_TITLE(err.errorCode, err.errorMsg);
    }];
}


#pragma mark -- TTTAttributedLabel delegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    if ([[url absoluteString] isEqualToString:@"privite"])
    {
        
    }
}

@end
