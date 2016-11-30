//
//  TabData.h
//  Shepherd
//
//  Created by Kevin Zhang (BCG DV) on 11/16/16.
//  Copyright © 2016 BCGDV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TabData : NSObject

@property(strong, nonatomic)NSString* title;
@property(strong, nonatomic)NSString* imgName;
@property(strong, nonatomic)NSString* selectedImgName;

-(id)initWithTitle:(NSString*)title andImgName:(NSString*)imgName andSelectedImgName:(NSString*)selectedImgName;

@end
