//
//  BaseTabBarController.m
//  Shepherd
//
//  Created by Kevin Zhang (BCG DV) on 11/16/16.
//  Copyright © 2016 BCGDV. All rights reserved.
//

#import "BaseTabBarController.h"
#import "TabData.h"

@implementation BaseTabBarController

-(id) initWithControllers:(NSArray*)controllers andTabData:(NSArray*)tabdata {
    self = [super init];
    self.controllers = controllers;
    self.tabdata = tabdata;
    
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    for (int i=0; i<[self.tabdata count]; i++) {
        TabData* td = [self.tabdata objectAtIndex:i];
        UIImage* img = td.imgName ? [UIImage imageNamed:td.imgName] : nil;
        UIImage* selectedImg = td.selectedImgName ? [UIImage imageNamed:td.selectedImgName] : nil;
        UITabBarItem* item = [[UITabBarItem alloc] initWithTitle:td.title image:img selectedImage:selectedImg];
        UIViewController* controller = [self.controllers objectAtIndex:i];
        controller.tabBarItem = item;
    }
    self.viewControllers = self.controllers;
}

@end

