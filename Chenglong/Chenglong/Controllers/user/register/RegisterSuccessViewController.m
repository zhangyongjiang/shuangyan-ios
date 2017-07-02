//
//  RegisterSuccessViewController.m
//  Chenglong
//
//  Created by wangyaochang on 2016/12/27.
//  Copyright © 2016年 Chenglong. All rights reserved.
//

#import "RegisterSuccessViewController.h"

@interface RegisterSuccessViewController ()

@end

@implementation RegisterSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"恭喜你注册成功";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextStepEvent:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kAppLoginSuccessNotificationKey object:nil];
}

@end
