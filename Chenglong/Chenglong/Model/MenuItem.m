//
//  MenuItem.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/13/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "MenuItem.h"

@implementation MenuItem

-(id)initWithText:(NSString *)text andImgName:(NSString *)imgName {
    self = [super init];
    self.text = text;
    self.imgName = imgName;
    self.enabled = [NSNumber numberWithBool:YES];
    return self;
}

@end
