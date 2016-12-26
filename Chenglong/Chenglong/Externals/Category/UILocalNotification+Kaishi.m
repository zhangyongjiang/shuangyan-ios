//
//  UILocalNotification+Kaishi.m
//  Kaishi
//
//  Created by Hyun Cho on 10/2/15.
//  Copyright (c) 2015 BCGDV. All rights reserved.
//

#import "UILocalNotification+Kaishi.h"

@implementation UILocalNotification (Kaishi)

+ (UILocalNotification*)notificationWithKey:(NSString*)key {
    NSArray* notifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    for ( UILocalNotification* notification in notifications ) {
        if ( notification.userInfo != nil ) {
            if ( notification.userInfo[key] != nil ) {
                return notification;
            }
        }
    }

    return nil;
}


+ (NSArray*)notificationsWithKey:(NSString*)key {
    NSMutableArray* result = [NSMutableArray array];
    
    NSArray* notifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    for ( UILocalNotification* notification in notifications ) {
        if ( notification.userInfo != nil ) {
            if ( notification.userInfo[key] != nil ) {
                [result addObject:notification];
            }
        }
    }
    
    return result;
}

@end
