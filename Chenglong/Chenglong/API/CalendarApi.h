/*Auto generated file. Do not modify. Tue Nov 29 16:01:13 CST 2016 */

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "APIError.h"
#import "WebService.h"
#import "Event.h"
#import "EventList.h"
#import "GenericResponse.h"

@interface CalendarApi : NSObject

+(NSURLSessionDataTask*) CalendarAPI_RemoveEvent:(NSString*)eventId onSuccess:(void (^)(Event *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) CalendarAPI_CreateEvent:(Event*)event onSuccess:(void (^)(Event *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) CalendarAPI_ListUserEvents:(NSNumber*)startTime page:(NSNumber*)page onSuccess:(void (^)(EventList *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) CalendarAPI_UpdateEvent:(Event*)event onSuccess:(void (^)(Event *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) CalendarAPI_RemoveAllEvents:(NSString*)parentEventId onSuccess:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock;


@end
