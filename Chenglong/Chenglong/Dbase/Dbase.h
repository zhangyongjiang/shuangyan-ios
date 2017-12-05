//
//  Dbase.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/21/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface Dbase : NSObject

+(Dbase*)shared;
-(void)setByName:(NSString*)name value:(NSString*)value;
-(NSString*)getByName:(NSString*)name;

@property(strong, nonatomic)FMDatabaseQueue* database;

@end
