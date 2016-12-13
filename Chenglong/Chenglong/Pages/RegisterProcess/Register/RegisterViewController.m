#import "RegisterViewController.h"

@implementation RegisterViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Register";
    
    self.page = [[RegisterPage alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.page];
    self.scrollView = self.page.scrollView;
    
    [self.page.submitBtn addTarget:self action:@selector(submit)];
}

-(void)submit {
    PhoneRegisterRequest *req = [[PhoneRegisterRequest alloc] init];
    req.phone = self.page.phoneField.text;
    req.validationCode = self.page.codeField.text;
    req.password = self.page.passwordField.text;
    [UserApi UserAPI_RegisterByPhone:req onSuccess:^(User *resp) {
        [self showErrorMessage:@"成功" err:nil];
    } onError:^(APIError *err) {
        [self showErrorMessage:@"注册错误" err:err];
    }];
}

@end
