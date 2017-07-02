//
//  ResetPwdViewController.m
//  Chenglong
//
//  Created by wangyaochang on 2016/12/28.
//  Copyright © 2016年 Chenglong. All rights reserved.
//

#import "ResetPwdViewController.h"
#import "ResetPwdView.h"

static CGFloat registerViewHeight = 340.f;

@interface ResetPwdViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) ResetPwdView *resetPwdView;
@end

@implementation ResetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"重置密码";
    
    [self configSubView];
    [self configItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configSubView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_BOUNDS_SIZE_WIDTH, SCREEN_BOUNDS_SIZE_HEIGHT)];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(SCREEN_BOUNDS_SIZE_WIDTH, SCREEN_BOUNDS_SIZE_HEIGHT);
    
    self.resetPwdView = [ResetPwdView loadFromNibWithFrame:CGRectMake(0, 0, SCREEN_BOUNDS_SIZE_WIDTH, registerViewHeight)];
    [self.resetPwdView.btnSubmit addTarget:self action:@selector(resetPwdEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.resetPwdView];
    
    [self.view addSubview:self.scrollView];
}

- (void)configItem
{
    
}

- (void)resetPwdEvent:(UIButton *)btn
{
    [self.view endEditing:YES];
    
    NSString* phoneNumber = [self.resetPwdView.tfPhone.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* pwd = [self.resetPwdView.tfPwd.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* code = [self.resetPwdView.tfCode.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* againPwd = [self.resetPwdView.tfAgainPwd.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ( phoneNumber.length == 0 ) {
        [self presentMessageTips:@"手机号不能为空"];
        return;
    }
    if ( code.length == 0 ) {
        [self presentMessageTips:@"验证码不能为空"];
        return;
    }
    if ( pwd.length == 0 || pwd.length < 6 || pwd.length > 16) {
        [self presentMessageTips:@"密码为6~16位数字字母组合"];
        return;
    }
    if ( againPwd.length == 0 || againPwd.length < 6 || againPwd.length > 16) {
        [self presentMessageTips:@"密码为6~16位数字字母组合"];
        return;
    }
    if (![pwd isEqualToString:againPwd]) {
        [self presentMessageTips:@"两次密码不一样"];
        return;
    }
    
    ResetPasswordRequest* resetRequest = [[ResetPasswordRequest alloc] init];
    resetRequest.phone = phoneNumber;
    resetRequest.password = pwd;
    resetRequest.validationCode = @"160718";//通用验证码 160718
    WeakSelf(weakSelf)
    [UserApi UserAPI_ResetPassword:resetRequest onSuccess:^(GenericResponse *resp) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [weakSelf presentMessageTips:@"密码修改成功"];
    } onError:^(APIError *err) {
        [weakSelf alertShowWithMsg:err.errorMsg];
    }];
}

#pragma mark - 键盘
- (void)keyboardChange:(NSNotification *)note
{
    NSDictionary *keyboardInformation = note.userInfo;
    NSValue *keyboardFrameEnd = [keyboardInformation valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [keyboardFrameEnd CGRectValue];
    _scrollView.height = SCREEN_BOUNDS_SIZE_HEIGHT - keyboardFrame.size.height - 64;
    _resetPwdView.height = registerViewHeight;
    self.scrollView.contentSize = CGSizeMake(SCREEN_BOUNDS_SIZE_WIDTH, registerViewHeight);
    
}
- (void)keyboardHidden:(NSNotification *)note
{
    _scrollView.height = SCREEN_BOUNDS_SIZE_HEIGHT;
    _resetPwdView.height = SCREEN_BOUNDS_SIZE_HEIGHT-64;
    self.scrollView.contentSize = CGSizeMake(SCREEN_BOUNDS_SIZE_WIDTH, SCREEN_BOUNDS_SIZE_HEIGHT);
}

@end
