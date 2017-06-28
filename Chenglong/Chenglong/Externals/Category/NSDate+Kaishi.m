//
//  NSDate+Kaishi.m
//  Kaishi
//
//  Created by Hyun Cho on 7/2/15.
//  Copyright (c) 2015 BCGDV. All rights reserved.
//

#import "NSDate+Kaishi.h"

const NSTimeInterval kOneMinuteInSecs = 60;
const NSTimeInterval kOneHourInSecs = 60 * 60;
const NSTimeInterval kOneDayInSecs = 60 * 60 * 24;
const NSTimeInterval kOneDayInMilliSecs = 60 * 60 * 24 * 1000;
const NSTimeInterval kOneWeekInMilliSecs = 7 * 60 * 60 * 24 * 1000;

@implementation NSDate (Kaishi)

+ (NSDate*)dateFromMillisecs:(NSNumber*)timeInMs {
    NSTimeInterval time = timeInMs.doubleValue * 0.001;
    return [NSDate dateWithTimeIntervalSince1970:time];
}

+ (NSNumber*)millisecs {
    return @([[NSDate date] timeIntervalSince1970] * 1000);
}

+ (NSDate*)dateFromMillisecsTime:(NSTimeInterval)timeInMs {
    return [NSDate dateWithTimeIntervalSince1970:timeInMs * 0.001];
}


+ (NSInteger)ageFromMillisecs:(NSNumber *)timeInMs {
    NSTimeInterval time = timeInMs.doubleValue * 0.001;
    NSDate *today = [NSDate date];
    NSDateComponents *ageComponents = [[NSCalendar currentCalendar]
                                       components:NSYearCalendarUnit
                                       fromDate:[NSDate dateWithTimeIntervalSince1970:time]
                                       toDate:today
                                       options:0];
    return ageComponents.year;
}


+ (NSInteger)monthFromMillisecs:(NSNumber *)timeInMs {
    NSTimeInterval time = timeInMs.doubleValue * 0.001;
    
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth fromDate:[NSDate dateWithTimeIntervalSince1970:time]];
    
    return [dateComponents month];
}


+ (NSInteger)dayFromMillisecs:(NSNumber *)timeInMs {
    NSTimeInterval time = timeInMs.doubleValue * 0.001;
    
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth fromDate:[NSDate dateWithTimeIntervalSince1970:time]];
    
    return [dateComponents day];
}


+ (NSDate*)maxDate:(NSDate*)date1 date2:(NSDate*)date2 {
    return (date1.timeIntervalSince1970 > date2.timeIntervalSince1970) ? date1 : date2;
}


+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    NSInteger day = [difference day];
    return day;
//    return ABS(day);
}

- (NSNumber*)millisecs {
    NSTimeInterval time = [self timeIntervalSince1970]; // in secs
    return @(time * 1000.0);
}


- (NSTimeInterval)millisecsTime {
    return [self timeIntervalSince1970] * 1000.0; // in secs * 1000.0
}


// accepts negative value for days ago
- (NSDate*)daysLater:(NSInteger)daysOffset {
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = daysOffset;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:self options:0];
    return nextDate;
}


// if the date is 12/31/2015 4:35:00PM, then the normalized version will be 12/31/2015 12:00:00AM
- (NSDate*)normalized {
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
    
    return [[NSCalendar currentCalendar] dateFromComponents:dateComponents];    
}


// if the date is 12/31/2015 4:35:00PM, then the normalized version will be 12/31/2015 11:59:59PM
- (NSDate*)endOfTheDay {
    NSDate* normalized = [self normalized];
    return [normalized dateByAddingTimeInterval:kOneDayInSecs - 1];
}


- (NSDate*)trimDateToNow { // if the date is in the future, it'll normalize to now.  If it's in the past, do nothing
    NSDate* now = [NSDate date];
    if ( [self compare:now] == NSOrderedDescending ) {
        return now;
    } else {
        return self;
    }
}

+(NSDate*)fromMilliseconds:(NSNumber *)millisecconds {
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:([millisecconds floatValue]/1000)];
    return date;
}

+(NSString*)toYmd:(NSNumber *)millisecconds {
    return [[self fromMilliseconds:millisecconds] toYmd];
}

+(NSString*)toYmdhm:(NSNumber *)millisecconds {
    return [[self fromMilliseconds:millisecconds] toYmdhm];
}

-(NSString*)toYmd {
    NSDateFormatter  * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    return [formatter stringFromDate:self];
}

-(NSString*)toYmdhm {
    NSDateFormatter  * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    return [formatter stringFromDate:self];
}

@end
