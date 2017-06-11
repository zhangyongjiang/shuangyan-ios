//
//  LocalMediaContent.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/10/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalMediaContent : NSObject

@property(strong,nonatomic) MediaContent* mediaContent;
@property(strong, nonatomic)NSString* filePath;

@end
