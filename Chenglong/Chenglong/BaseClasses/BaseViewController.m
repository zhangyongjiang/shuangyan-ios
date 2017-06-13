//
//  BaseViewController.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationPushController:) name:NotificationPushController object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRefreshControl:) name:NotificationRefreshControl object:nil];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)notificationRefreshControl:(NSNotification*)noti {
    [self refreshPage];
}

-(void) refreshPage {
}

-(void)notificationPushController:(NSNotification*)noti {
    if (self.isViewLoaded && self.view.window) {
        UIView* subview = noti.object;
        if([subview isSameViewOrChildOf:self.view]) {
            UIViewController* controller = [noti.userInfo objectForKey:@"controller"];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

@end
