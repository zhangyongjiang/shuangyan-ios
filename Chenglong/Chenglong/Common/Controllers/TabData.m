//
//  TabData.m
//  Shepherd
//
//  Created by Kevin Zhang (BCG DV) on 11/16/16.
//  Copyright © 2016 BCGDV. All rights reserved.
//

#import "TabData.h"

@implementation TabData

-(id)initWithTitle:(NSString*)title andImgName:(NSString*)imgName  andSelectedImgName:(NSString*)selectedImgName {
    self = [super init];
    self.title = title;
    self.imgName = imgName;
    self.selectedImgName = selectedImgName;
    return self;
}

@end
