//
//  AppDelegate.m
//  Quber
//
//  Created by Kevin Zhang on 7/17/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

#import "AppDelegate.h"
#import "WebService.h"
#import "LoginViewController.h"
#import "MainTabBarController.h"
#import "Dbase.h"
#import "BaseNavigationController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface AppDelegate ()
{
    BOOL isFirstUseApp;
    AVPlayer* player;
    AVPlayerLayer* avPlayerLayer;
}

@property(weak, nonatomic)UIView* viewForPlayer;

@end

@implementation AppDelegate

-(AVPlayer*)sharedPlayer {
    if(player) return player;
    player = [[AVPlayer alloc] init];
    return player;
}

-(void)addPlayerToView:(UIView*)view {
    if(view == self.viewForPlayer) {
        avPlayerLayer.frame = view.bounds;
        return;
    }
    [player seekToTime:CMTimeMake(0, player.currentItem.asset.duration.timescale)
            toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    self.viewForPlayer = view;
    AVPlayerLayer* layer = [AVPlayerLayer playerLayerWithPlayer:player];
    layer.frame = view.bounds;
    [view.layer addSublayer:layer];
    layer.backgroundColor = [UIColor clearColor].CGColor;
    [layer setVideoGravity:AVLayerVideoGravityResizeAspect];
    layer.frame = view.bounds;
    avPlayerLayer = layer;
}

-(void)runOnBackend
{
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:&setCategoryErr];
    [[AVAudioSession sharedInstance] setActive:YES error:&activationErr];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(background:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(foreground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

-(void)background:(NSNotification*)noti {
    [avPlayerLayer removeFromSuperlayer];
    avPlayerLayer = nil;
    [player play];
}

-(void)foreground:(NSNotification*)noti {
    if(avPlayerLayer) return;
    avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    avPlayerLayer.frame = self.viewForPlayer.bounds;
    [self.viewForPlayer.layer addSublayer:avPlayerLayer];
    avPlayerLayer.backgroundColor = [UIColor clearColor].CGColor;
    [avPlayerLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self sharedPlayer];
    [self runOnBackend];
    
    UIWindow* window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.backgroundColor = [UIColor whiteColor];
    [window makeKeyAndVisible];
    self.window = window;
    
    if ( [[NSUserDefaults standardUserDefaults] objectForKey:kOauthTokenFirstTimeKey] == nil )
    {
        // save that we have opened this app
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:kOauthTokenFirstTimeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        isFirstUseApp = YES;
    }
    else
    {
        isFirstUseApp = NO;
    }
    
    [Config shared]; // initialize the config for dev bundle loading
    [WebService loadCookies]; // this loads user session info
    
    if ( [Global loggedInUser] != nil) {
        
        MainTabBarController* tabBarController = [[MainTabBarController alloc] initWithNibName:nil bundle:nil];
        self.window.rootViewController = tabBarController;
        
    } else {
        
        LoginViewController* loginViewController = [[LoginViewController alloc] init];
        BaseNavigationController* navController = [[BaseNavigationController alloc] initWithRootViewController:loginViewController];
        self.window.rootViewController = navController;
    }
    
    [self setupAppearance];
    [self setupNotification];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0; // TODO: temporary solution
    
    return YES;
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

#pragma mark - 添加通知
- (void)setupNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoginSuccess:) name:kAppLoginSuccessNotificationKey object:nil];
}

#pragma Setup
- (void)setupAppearance {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [UINavigationBar appearance].tintColor = [UIColor kaishiColor:UIColorTypeThemeSelected];
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor kaishiColor:UIColorTypeThemeSelected], NSFontAttributeName : [UIFont systemFontOfSize:18.f]};
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    if ( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") ) {
        [UITabBar appearance].translucent = NO;
    }
    [UITabBar appearance].backgroundColor = [UIColor whiteColor];
    [UITabBar appearance].tintColor = [UIColor kaishiColor:UIColorTypeThemeSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor kaishiColor:UIColorTypeBarTitleColor],NSFontAttributeName : [UIFont systemFontOfSize:11.f]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor kaishiColor:UIColorTypeThemeSelected],NSFontAttributeName : [UIFont systemFontOfSize:11.f]} forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -4)];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.f]} forState:UIControlStateNormal];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    UIImage* image = [[UIImage imageNamed:@"nav_btn_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(0, image.size.width, 0, 0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    // general progress view
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
}

#pragma mark - Login/Out

- (void)logout
{
    //退出
    [Global setLoggedInUser:nil];
    
    // clear image caches
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDisk];
    LoginViewController* loginViewController = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
    BaseNavigationController* navController = [[BaseNavigationController alloc] initWithRootViewController:loginViewController];
    self.window.rootViewController = navController;
}
- (void)onLoginSuccess:(NSNotification *)noti
{
    MainTabBarController* tabBarController = [[MainTabBarController alloc] initWithNibName:nil bundle:nil];
    self.window.rootViewController = tabBarController;
}

+(AppDelegate*)appDelegate {
    AppDelegate* del = (AppDelegate*)[UIApplication sharedApplication].delegate;
    return del;
}
@end
