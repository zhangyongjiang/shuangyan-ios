//
//  RegisterViewController.m
//  Chenglong
//
//  Created by wangyaochang on 2016/12/27.
//  Copyright © 2016年 Chenglong. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterView.h"
#import "RegisterSuccessViewController.h"

static CGFloat registerViewHeight = 380.f;

@interface RegisterViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) RegisterView *registerView;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"注册";
    
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
    
    self.registerView = [RegisterView loadFromNibWithFrame:CGRectMake(0, 0, SCREEN_BOUNDS_SIZE_WIDTH, registerViewHeight)];
    [self.registerView.btnRegister addTarget:self action:@selector(registerEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.registerView];
    
    [self.view addSubview:self.scrollView];
}

- (void)configItem
{
    
}

- (void)registerEvent:(UIButton *)btn
{
    [self.view endEditing:YES];
    
    NSString* phoneNumber = [self.registerView.tfPhone.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* pwd = [self.registerView.tfPwd.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* code = [self.registerView.tfCode.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* name = [self.registerView.tfNickName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
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
    if ( name.length == 0 ) {
        [self presentMessageTips:@"昵称不能为空"];
        return;
    }
    PhoneRegisterRequest* registerRequest = [[PhoneRegisterRequest alloc] init];
    registerRequest.phone = phoneNumber;
    registerRequest.password = pwd;
    registerRequest.validationCode = @"160718";//通用验证码 160718
    registerRequest.name = name;
    WeakSelf(weakSelf)
    [SVProgressHUD showWithStatus:@"注册中"];
    [UserApi UserAPI_RegisterByPhone:registerRequest onSuccess:^(User *resp) {
        
        [SVProgressHUD dismiss];
        [Global setLoggedInUser:resp];
        RegisterSuccessViewController *registerSuccess = [RegisterSuccessViewController loadFromNib];
        [weakSelf.navigationController pushViewController:registerSuccess animated:YES];
        
    } onError:^(APIError *err) {
        [SVProgressHUD dismiss];
        [weakSelf alertShowWithMsg:@"手机已经被注册"];
    }];
}

#pragma mark - 键盘
- (void)keyboardChange:(NSNotification *)note
{
    NSDictionary *keyboardInformation = note.userInfo;
    NSValue *keyboardFrameEnd = [keyboardInformation valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [keyboardFrameEnd CGRectValue];
    _scrollView.height = SCREEN_BOUNDS_SIZE_HEIGHT - keyboardFrame.size.height - 64;
    _registerView.height = registerViewHeight;
    self.scrollView.contentSize = CGSizeMake(SCREEN_BOUNDS_SIZE_WIDTH, registerViewHeight);
    
}
- (void)keyboardHidden:(NSNotification *)note
{
    _scrollView.height = SCREEN_BOUNDS_SIZE_HEIGHT;
    _registerView.height = SCREEN_BOUNDS_SIZE_HEIGHT-64;
    self.scrollView.contentSize = CGSizeMake(SCREEN_BOUNDS_SIZE_WIDTH, SCREEN_BOUNDS_SIZE_HEIGHT);
}

@end
