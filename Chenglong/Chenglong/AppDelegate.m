//
//  AppDelegate.m
//  Quber
//
//  Created by Kevin Zhang on 7/17/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

#import "AppDelegate.h"
#import "UberViewController.h"
#import "NSSlidePanelController.h"
#import "NavigationControllerBase.h"
#import "MenuViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "SplashViewController.h"
#import "APBAlertView.h"
#import "RegisterNaviController.h"

@interface AppDelegate ()

@property(strong, nonatomic) NSSlidePanelController* slidePanelController;
@property(strong, nonatomic) NavigationControllerBase* navController;
@property(strong, nonatomic) NSSlidePanelController* resumeController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIWindow* window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.backgroundColor = [UIColor whiteColor];
    [window makeKeyAndVisible];
    self.window = window;
    
    [self splash];
    
    return YES;
}

-(void)splash {
    SplashViewController* controller = [[SplashViewController alloc] init];
    self.window.rootViewController = controller;
}

-(void)setupSlideMenu {
    self.slidePanelController = [[NSSlidePanelController alloc] init];
    self.slidePanelController.shouldDelegateAutorotateToVisiblePanel = false;
    
    self.navController = [[NavigationControllerBase alloc] init];
    self.slidePanelController.centerPanel = self.navController;
    UberViewController* controller = [[UberViewController alloc] init];
    [self.navController pushViewController:controller animated: YES];
    self.navController.navigationBar.translucent = YES;
    self.slidePanelController.leftPanel = [[MenuViewController alloc] init];
    
    self.window.rootViewController = self.slidePanelController;
}

-(void)askForLocation {
    CLLocationManager* myLocationManager = [[CLLocationManager alloc] init];
    [myLocationManager requestWhenInUseAuthorization];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


+(AppDelegate*)getInstance {
    return [UIApplication sharedApplication].delegate;
}

-(void) showViewController:(UIViewController*)controller {
    //    [self.slidePanelController showCenterPanelAnimated:YES];
    //    for (UIViewController* c in self.navController.viewControllers) {
    //        [[NSNotificationCenter defaultCenter] removeObserver:c];
    //    }
    //    [self.navController setViewControllers:@[controller]];
}

-(void) pushViewController:(UIViewController*)controller {
    //    [self.slidePanelController showCenterPanelAnimated:YES];
    //    [self.navController pushViewController:controller animated:YES];
}

-(void)alertWithTitle:(NSString *)title andMsg:(NSString *)msg handler:(void (^)(UIAlertAction *action))handler{
    if ([UIAlertController class])
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:handler]];
        [self.window.rootViewController presentViewController:alert animated:YES completion:^{
        }];
    }
    else
    {
        APBAlertView *alertView = [[APBAlertView alloc]
                                   initWithTitle:title
                                   message:msg
                                   cancelButtonTitle:nil
                                   otherButtonTitles:@[@"OK"]
                                   cancelHandler:^{
                                   }
                                   confirmationHandler:^(NSInteger otherButtonIndex) {
                                       handler(nil);
                                   }];
        [alertView show];
    }
}

-(void)presentViewController:(UIViewController*)controller completion:(void (^)(void))completion{
    //    [self.navController presentViewController:controller animated:YES completion:completion];
}

-(void)alertWithTitle:(NSString *)title andMsg:(NSString *)msg ok:(void (^)(UIAlertAction *action))ok  cancel:(void (^)(UIAlertAction *action))cancel{
    if ([UIAlertController class]) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:ok]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:cancel]];
        //        [self.navController presentViewController:alert animated:YES completion:nil];
    }
    else {
        APBAlertView *alertView = [[APBAlertView alloc]
                                   initWithTitle:title
                                   message:msg
                                   cancelButtonTitle:@"Cancel"
                                   otherButtonTitles:@[@"OK"]
                                   cancelHandler:^{
                                       cancel(nil);
                                   }
                                   confirmationHandler:^(NSInteger otherButtonIndex) {
                                       ok(nil);
                                   }];
        [alertView show];
    }
}

-(void)startRegisterProcess {
    RegisterNaviController* controller = [[RegisterNaviController alloc] init];
    self.window.rootViewController = controller;
}

-(void)gotoMainPage {
    
}

@end
