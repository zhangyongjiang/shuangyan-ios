//
//  NSDate+Kaishi.h
//  Kaishi
//
//  Created by Hyun Cho on 7/2/15.
//  Copyright (c) 2015 BCGDV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Kaishi)

+ (NSDate*)dateFromMillisecs:(NSNumber*)timeInMs;
+ (NSDate*)dateFromMillisecsTime:(NSTimeInterval)timeInMs;
+ (NSNumber*)millisecs;

+ (NSInteger)ageFromMillisecs:(NSNumber *)timeInMs;

+ (NSInteger)monthFromMillisecs:(NSNumber *)timeInMs;
+ (NSInteger)dayFromMillisecs:(NSNumber *)timeInMs;

+ (NSDate*)maxDate:(NSDate*)date1 date2:(NSDate*)date2;
+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;

- (NSNumber*)millisecs;
- (NSTimeInterval)millisecsTime;
- (NSDate*)daysLater:(NSInteger)daysOffset; // accepts negative value for days ago
- (NSDate*)normalized; // if the date is 12/31/2015 4:35:00PM, then the normalized version will be 12/31/2015 12:00:00AM
- (NSDate*)endOfTheDay; // if the date is 12/31/2015 4:35:00PM, then the normalized version will be 12/31/2015 11:59:59PM
- (NSDate*)trimDateToNow; // if the date is in the future, return current date.  If it's in the past, do nothing.

@end

extern const NSTimeInterval kOneMinuteInSecs;
extern const NSTimeInterval kOneHourInSecs;
extern const NSTimeInterval kOneDayInSecs;
extern const NSTimeInterval kOneDayInMilliSecs;
extern const NSTimeInterval kOneWeekInMilliSecs;
