//
//  BaseTabBarController.h
//  Shepherd
//
//  Created by Kevin Zhang (BCG DV) on 11/16/16.
//  Copyright © 2016 BCGDV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTabBarController : UITabBarController

@property(strong, nonatomic)NSArray* tabdata;
@property(strong, nonatomic)NSArray* controllers;

-(id) initWithControllers:(NSArray*)controllers andTabData:(NSArray*)tabdata;

@end
