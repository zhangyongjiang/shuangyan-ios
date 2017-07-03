//
//  MenuItem.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/13/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuItem : NSObject

@property(strong, nonatomic) NSString* text;
@property(strong, nonatomic) NSString* imgName;
@property(strong, nonatomic) NSNumber* enabled;

-(id)initWithText:(NSString*)text andImgName:(NSString*)imgName;

@end
