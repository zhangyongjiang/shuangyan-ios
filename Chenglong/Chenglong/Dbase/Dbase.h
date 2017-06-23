//
//  Dbase.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/21/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dbase : NSObject

+(Dbase*)shared;

-(BOOL)saveList:(CourseDetailsList*)list;

-(BOOL)save:(CourseDetails *)cd ;

-(CourseDetails*)getCourseDetailsById:(NSString *)cid ;

-(CourseDetails*)fromJsonString:(NSString*)jsonstr ;

-(NSMutableArray*)getChildCourseDetails:(NSString*)parent ;

-(NSMutableArray*)getCourseDetailsListByColumn:(NSString*)columnName andValue:(NSObject*)value ;

-(CourseDetailsList*)getCourseDetailsList:(NSString*)cid;

-(CourseDetailsList*)getUserRootCourseDetailsList:(NSString*)userId ;

@end
