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
#import "PlayListNavViewController.h"


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

    self.view.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tabBar.accessibilityLabel = @"MainTabBar";
    self.tabBar.translucent = NO;
    self.delegate = self;
    
    PlayListNavViewController* playNavViewController = [PlayListNavViewController new];
    [self setViewControllers:@[[MyFileNavigationController new],
                               [CommunityNavigationController new],
                               playNavViewController,
                               [ProfileNavigationController new]
                               ]];
    [self addObser];
    if(playNavViewController.view)
        NSLog(@"preload view");
}

- (void)addObser
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleFullscreen:) name:NotificationFullscreen object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playCourseNotiHandler:) name:NotificationPlayCourse object:nil];
}

-(void)playCourseNotiHandler:(NSNotification*)noti {
    if(self.selectedIndex == 2)
        return;

    self.selectedIndex = 2;
    return;
    
    int controllerIndex = 2;
    UIView * fromView = self.selectedViewController.view;
    UIView * toView = [[self.viewControllers objectAtIndex:controllerIndex] view];
    
    // Transition using a page curl.
    WeakSelf(weakSelf  )
    [UIView transitionFromView:fromView
                        toView:toView
                      duration:0.6
                       options:(controllerIndex > self.selectedIndex ? UIViewAnimationOptionTransitionCurlUp : UIViewAnimationOptionTransitionCurlDown)
                    completion:^(BOOL finished) {
                        if (finished) {
                            weakSelf.selectedIndex = controllerIndex;
                        }
                    }];
    
}

-(void)toggleFullscreen:(NSNotification*)noti
{
    if([AppDelegate isLandscape])
        return;
    self.tabBar.hidden = !self.tabBar.hidden;
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
        toast(@"登录错误。请重新登录");
            AppDelegate* del = (AppDelegate*)[UIApplication sharedApplication].delegate;
            [del logout];
    }];
}

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return viewController != tabBarController.selectedViewController;
}

- (BOOL)shouldAutorotate {
    return self.selectedViewController.shouldAutorotate;
}

- (NSUInteger)supportedInterfaceOrientations {
    return self.selectedViewController.supportedInterfaceOrientations;
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
         if(orientation == UIInterfaceOrientationPortrait) {
             NSLog(@"UIInterfaceOrientationPortrait");
             self.tabBar.hidden = NO;
         }
         if(orientation == UIInterfaceOrientationPortraitUpsideDown) {
             NSLog(@"UIInterfaceOrientationPortraitUpsideDown");
             self.tabBar.hidden = NO;
         }
         if(orientation == UIInterfaceOrientationLandscapeLeft) {
             NSLog(@"UIInterfaceOrientationLandscapeLeft");
             self.tabBar.hidden = YES;
         }
         if(orientation == UIInterfaceOrientationLandscapeRight) {
             NSLog(@"UIInterfaceOrientationLandscapeRight");
             self.tabBar.hidden = YES;
         }
         if(orientation == UIInterfaceOrientationUnknown) {
             NSLog(@"UIInterfaceOrientationUnknown");
             self.tabBar.hidden = NO;
         }
         // do whatever
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

@end
