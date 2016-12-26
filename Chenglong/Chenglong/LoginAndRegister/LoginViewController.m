//
//  LoginViewController.m
//  Chenglong
//
//  Created by wangyaochang on 2016/12/25.
//  Copyright © 2016年 Chenglong. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"

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
    [self.scrollView addSubview:self.loginView];
    
    [self.view addSubview:self.scrollView];
}

- (void)configItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(registerEvent:)];
}

- (void)registerEvent:(UIBarButtonItem *)item
{
    
}

#pragma mark - 键盘
- (void)keyboardChange:(NSNotification *)note
{
    NSDictionary *keyboardInformation = note.userInfo;
    NSValue *keyboardFrameEnd = [keyboardInformation valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [keyboardFrameEnd CGRectValue];
    _scrollView.height = SCREEN_BOUNDS_SIZE_HEIGHT - keyboardFrame.size.height - 64;
    _loginView.height = SCREEN_BOUNDS_SIZE_HEIGHT;
    
}
- (void)keyboardHidden:(NSNotification *)note
{
    _scrollView.height = SCREEN_BOUNDS_SIZE_HEIGHT - 64;
    _loginView.height = SCREEN_BOUNDS_SIZE_HEIGHT;
}
@end
