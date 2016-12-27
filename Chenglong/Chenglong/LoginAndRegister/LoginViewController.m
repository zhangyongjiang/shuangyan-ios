//
//  LoginViewController.m
//  Chenglong
//
//  Created by wangyaochang on 2016/12/25.
//  Copyright © 2016年 Chenglong. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"
#import "RegisterViewController.h"

static CGFloat loginViewHeight = 450.f;

@interface LoginViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) LoginView *loginView;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"登录";
    
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
    
    self.loginView = [LoginView loadFromNibWithFrame:CGRectMake(0, 0, SCREEN_BOUNDS_SIZE_WIDTH, SCREEN_BOUNDS_SIZE_HEIGHT-64)];
    [self.loginView.btnLogin addTarget:self action:@selector(loginEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginView.btnForgetPwd addTarget:self action:@selector(resetPwdEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.loginView];
    
    [self.view addSubview:self.scrollView];
}

- (void)configItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(registerEvent:)];
}

- (void)registerEvent:(UIBarButtonItem *)item
{
    RegisterViewController *registerCon = [[RegisterViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:registerCon animated:YES];
}

- (void)loginEvent:(UIButton *)btn
{
    [self.view endEditing:YES];
    
    NSString* phoneNumber = [self.loginView.tfPhone.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* pwd = [self.loginView.tfPwd.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ( phoneNumber.length == 0 ) {
        [self presentMessageTips:@"手机号不能为空"];
        return;
    }
    if ( pwd.length == 0 ) {
        [self presentMessageTips:@"密码不能为空"];
        return;
    }
    PhoneLoginRequest* loginRequest = [[PhoneLoginRequest alloc] init];
    loginRequest.phone = phoneNumber;
    loginRequest.password = pwd;//通用验证码 160718
    
    [SVProgressHUD showWithStatus:@"登录中"];
    WeakSelf(weakSelf)
    [UserApi UserAPI_PhoneLogin:loginRequest onSuccess:^(User *resp) {
        
        [SVProgressHUD dismiss];
        
        [Global setLoggedInUser:resp];
        [[NSNotificationCenter defaultCenter] postNotificationName:kAppLoginSuccessNotificationKey object:resp];
        
    } onError:^(APIError *err) {
        [SVProgressHUD dismiss];
        FDAlertView *alert = [[FDAlertView alloc] initWithTitle:nil message:@"手机号格式不对或密码不对" delegate:nil cancelButtonTitle:@"忘记密码" otherButtonTitles:@"确定", nil];
        alert.whenDidSelectCancelButton = ^{
            [weakSelf resetPwdEvent:nil];
        };
        [alert show];
    }];
}

- (void)resetPwdEvent:(UIButton *)btn
{
    
}

#pragma mark - 键盘
- (void)keyboardChange:(NSNotification *)note
{
    NSDictionary *keyboardInformation = note.userInfo;
    NSValue *keyboardFrameEnd = [keyboardInformation valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [keyboardFrameEnd CGRectValue];
    _scrollView.height = SCREEN_BOUNDS_SIZE_HEIGHT - keyboardFrame.size.height - 64;
    _loginView.height = loginViewHeight;
    self.scrollView.contentSize = CGSizeMake(SCREEN_BOUNDS_SIZE_WIDTH, loginViewHeight);
    
}
- (void)keyboardHidden:(NSNotification *)note
{
    _scrollView.height = SCREEN_BOUNDS_SIZE_HEIGHT;
    _loginView.height = SCREEN_BOUNDS_SIZE_HEIGHT-64;
    self.scrollView.contentSize = CGSizeMake(SCREEN_BOUNDS_SIZE_WIDTH, SCREEN_BOUNDS_SIZE_HEIGHT);
}

@end
