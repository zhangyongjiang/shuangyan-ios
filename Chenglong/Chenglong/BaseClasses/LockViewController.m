//
//  BaseViewController.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "LockViewController.h"

@interface LockViewController ()

@property (nonatomic, assign) int lockScreen;
@property (nonatomic, strong) UIView* lockView;

@end

@implementation LockViewController

-(void)lockScreenClicked {
    static NSTimeInterval lastClickTime = 0;
    static int clickCnt = 0;
    
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    if(now - lastClickTime > 0.3) {
        clickCnt = 0;
        lastClickTime = now;
        return;
    }
    lastClickTime = now;
    clickCnt++;
    if(clickCnt >= 4) {
        [self toggleLockScreen];
        clickCnt = 0;
    }
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.lockScreen = 0;
    self.view.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    self.lockView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIView screenWidth], [UIView screenHeight])];
    self.lockView.hidden = YES;
    self.lockView.userInteractionEnabled = YES;
    self.lockView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.lockView];
    [self.lockView addTarget:self action:@selector(lockScreenClicked)];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiLockScreenHandler:) name:NotificationLockScreen object:nil];

}

-(void)notiLockScreenHandler:(NSNotification*)noti {
    [self toggleLockScreen];
}

-(void) toggleLockScreen {
    if(self.lockScreen == 0) {
        toast(@"屏幕锁定");
        self.lockView.hidden = NO;
        self.lockView.backgroundColor = [UIColor clearColor];
        [self.view bringSubviewToFront:self.lockView];
    }
    //        else if(self.lockScreen == 1) {
    //            self.lockView.backgroundColor = [UIColor blackColor];
    //            self.lockView.hidden = NO;
    //            [self.view bringSubviewToFront:self.lockView];
    //        }
    //        else if(self.lockScreen == 2) {
    else {
        toast(@"屏幕解除锁定");
        self.lockView.hidden = YES;
        self.lockView.backgroundColor = [UIColor clearColor];
        [self.view bringSubviewToFront:self.lockView];
    }
    self.lockScreen = (self.lockScreen+1)%2;
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.lockView.frame = CGRectMake(0, 0, [UIView screenWidth], [UIView screenHeight]);
}

- (BOOL)shouldAutorotate {
    return self.lockScreen == 0;
}

@end
