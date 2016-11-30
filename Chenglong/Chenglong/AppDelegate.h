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

+(AppDelegate*)getInstance;

- (void) showViewController:(UIViewController*)controller;
- (void) pushViewController:(UIViewController*)controller ;
- (void) presentViewController:(UIViewController*)controller completion:(void (^)(void))completion;
- (void) alertWithTitle:(NSString *)title andMsg:(NSString *)msg handler:(void (^)(UIAlertAction *action))handler;
- (void) alertWithTitle:(NSString *)title andMsg:(NSString *)msg ok:(void (^)(UIAlertAction *action))ok  cancel:(void (^)(UIAlertAction *action))cancel;

-(void)startRegisterProcess;
-(void)gotoMainPage;

@end

