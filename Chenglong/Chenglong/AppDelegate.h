//
//  AppDelegate.h
//  Quber
//
//  Created by Kevin Zhang on 7/17/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (int)version;
- (void)logout;
- (AVPlayer*)sharedPlayer;
-(void)addPlayerToView:(UIView*)view;

+(AppDelegate*)appDelegate;

@end

