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

-(CourseDetails*) getCourseDetailsById:(NSString*)cid;
-(BOOL) save:(CourseDetails*)cd;

@end
