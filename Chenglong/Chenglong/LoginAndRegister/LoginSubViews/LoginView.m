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
    UIImageView *phontIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_phone_icon"]];
    phontIcon.frame = CGRectMake(0, 0, 26, 16);
    phontIcon.contentMode = UIViewContentModeLeft;
    _tfPhone.leftView = phontIcon;
    UIImageView *pwdIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_pwd_icon"]];
    pwdIcon.frame = CGRectMake(0, 0, 26, 16);
    pwdIcon.contentMode = UIViewContentModeLeft;
    _tfPwd.leftView = pwdIcon;
    
    NSString *imgUrl = KUserDefaultsGetValue(kCachedUserImgPath);
    if (imgUrl) {
        [_headerView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil];
    }
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}
@end
