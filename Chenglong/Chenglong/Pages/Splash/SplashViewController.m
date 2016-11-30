#import "SplashViewController.h"
#import "AppDelegate.h"

@implementation SplashViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Splash";
    
    self.page = [[SplashPage alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.page];

    self.scrollView = self.page.scrollView;
    
    [self performSelector:@selector(next) withObject:nil afterDelay:3];
}

-(void)next {
    if([NSUserDefaults isRegisteredUser]) {
        [[AppDelegate getInstance] gotoMainPage];
    }
    else {
        [[AppDelegate getInstance] startRegisterProcess];
    }
}
@end
