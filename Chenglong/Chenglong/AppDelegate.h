//
//  AppDelegate.h
//  Quber
//
//  Created by Kevin Zhang on 7/17/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (int)version;
- (void)logout;

+(AppDelegate*)appDelegate;
+(NSString*)userAccessToken;
+ (NSString*)appendAccessTokenToUrl:(NSString*)url;
+(BOOL)isLandscape;

@end

