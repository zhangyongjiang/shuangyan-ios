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
#import "CommunityViewController.h"
#import "ProfileViewController.h"

@interface MainTabBarController ()<UITabBarControllerDelegate>
{
    UIViewController * currSelectViewController;
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
    
    
    FileViewController * file = [[FileViewController alloc] initWithNibName:nil bundle:nil];
    SameCityViewController* city = [[SameCityViewController alloc] initWithNibName:nil bundle:nil];
    CommunityViewController* community = [[CommunityViewController alloc] initWithNibName:nil bundle:nil];
    ProfileViewController* profile = [[ProfileViewController alloc] initWithNibName:nil bundle:nil];
    
    currSelectViewController = file;
    
    [self setViewControllers:@[[[UINavigationController alloc] initWithRootViewController:file],
                               [[UINavigationController alloc] initWithRootViewController:city],
                               [[UINavigationController alloc] initWithRootViewController:community],
                               [[UINavigationController alloc] initWithRootViewController:profile]
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
//    User *user;
    
//    UserDetails *userDetail = [Global loggedInUserDetails];
//    if ( [Global loggedInUser] == nil || [Global cachedUser].privateInfo == nil || [Global cachedUser].privateInfo.phone == nil || userDetail == nil)
//    {
//        // we want to have a temporary cached user with limited info (id, duedate, nickname) so that dashboard and other controllers don't fail with server delays
//        User* cachedUser = [Global cachedUser];
//        if ( cachedUser != nil ) {
//            [Global setLoggedInUser:cachedUser];
//        }
//        
//        // update the real me
//        [KaishiApi UserAPI_Me:^(UserDetails *resp) {
//            
//            // there was an error... try logging out
//            if ( resp == nil || resp.user == nil ) {
//                ALERT_VIEW_WITH_TITLE(KaishiLocalizedString(@"UserSessionExpired", nil), nil);
//                
//                AppDelegate* del = (AppDelegate*)[UIApplication sharedApplication].delegate;
//                [del logout];
//            }
//            else
//            {
//                [Global setLoggedInUser:resp.user];
//                [Global setLoggedInUserDetails:resp];
//                
//                NSString* userId = [cachedUser.id stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
//                @try {
//                    [YunBaService setAlias:[userId copy] resultBlock:^(BOOL succ, NSError *error) {
//                    }];
//                } @catch (NSException *exception) {
//                    
//                }
//                
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"MeLoaded" object:nil];
//            }
//            
//        } onError:^(APIError *err) {
//            
//            if ( err.statusCode == 401 ) {
//                ALERT_VIEW_WITH_TITLE(KaishiLocalizedString(@"UserSessionExpired", nil), nil);
//                
//                AppDelegate* del = (AppDelegate*)[UIApplication sharedApplication].delegate;
//                [del logout];
//            } else {
//                ALERT_VIEW_WITH_TITLE(err.errorCode, err.errorMsg);
//            }
//            
//        } onRetry:^(NSURLSessionDataTask *oldOperation, NSURLSessionDataTask *newOperation) {
//        }];
//        
//    }
//    else
//    {
//        user = [Global loggedInUser];
//        
//        NSString* userId = [user.id stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
//        @try {
//            [YunBaService setAlias:[userId copy] resultBlock:^(BOOL succ, NSError *error) {
//            }];
//        } @catch (NSException *exception) {
//            
//        }
//    }
}

@end
