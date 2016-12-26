//
//  UILocalNotification+Kaishi.h
//  Kaishi
//
//  Created by Hyun Cho on 10/2/15.
//  Copyright (c) 2015 BCGDV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILocalNotification (Kaishi)

+ (UILocalNotification*)notificationWithKey:(NSString*)key;
+ (NSArray*)notificationsWithKey:(NSString*)key;

@end
