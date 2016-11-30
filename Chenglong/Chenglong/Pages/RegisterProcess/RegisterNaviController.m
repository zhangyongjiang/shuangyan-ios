//
//  RegisterNaviController.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 11/30/16.
//  Copyright © 2016 Chenglong. All rights reserved.
//

#import "RegisterNaviController.h"
#import "RegisterViewController.h"

@implementation RegisterNaviController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTransparentTitleBar];
    
    RegisterViewController* controller = [[RegisterViewController alloc] init];
    self.viewControllers = @[controller];
}

@end
