#import "RegisterViewController.h"

@implementation RegisterViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Register";
    
    self.page = [[RegisterPage alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.page];

    self.scrollView = self.page.scrollView;
}

@end
