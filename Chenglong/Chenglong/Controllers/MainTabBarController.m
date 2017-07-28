//
//  MainTabBarController.m
//  Kaishi
//
//  Created by Hyun Cho on 6/15/15.
//  Copyright (c) 2015 BCGDV. All rights reserved.
//


#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "FileViewController.h"
#import "SameCityViewController.h"
#import "ProfileViewController.h"
#import "FileListViewController.h"
#import "OnlineSearchListViewController.h"
#import "BaseNavigationController.h"
#import "CourseTreeViewController.h"
#import "MyFileNavigationController.h"
#import "CommunityNavigationController.h"
#import "ProfileNavigationController.h"


@interface MainTabBarController ()<UITabBarControllerDelegate>
{
}

@property (nonatomic, assign) BOOL firstViewDidAppear;
@end


@implementation MainTabBarController

#pragma mark - View Life Cycle

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadLoggedInUser];

    self.tabBar.accessibilityLabel = @"MainTabBar";
    self.tabBar.translucent = NO;
    self.delegate = self;
    
    [self setViewControllers:@[[MyFileNavigationController new],
                               [CommunityNavigationController new],
                               [ProfileNavigationController new]
                               ]];
    [self addObser];
    
}

- (void)addObser
{
   
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Setup

- (void)loadLoggedInUser {
    
    [UserApi UserAPI_Me:^(User *resp) {
        // there was an error... try logging out
        if ( resp == nil ) {
            AppDelegate* del = (AppDelegate*)[UIApplication sharedApplication].delegate;
            [del logout];
        }
        else
        {
            [Global setLoggedInUser:resp];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetMeInfoSuccessNotificationKey object:nil];
        }
    } onError:^(APIError *err) {
        if ( err.statusCode == 401 ) {
            AppDelegate* del = (AppDelegate*)[UIApplication sharedApplication].delegate;
            [del logout];
        } else {
        
        }
    }];
}

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return viewController != tabBarController.selectedViewController;
}

@end
