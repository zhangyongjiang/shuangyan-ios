/*Auto generated file. Do not modify. Tue Nov 29 16:01:13 CST 2016 */

#import "CalendarApi.h"
#import "ObjectMapper.h"

@implementation CalendarApi

+(NSURLSessionDataTask*) CalendarAPI_RemoveEvent:(NSString*)eventId onSuccess:(void (^)(Event *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/calendar-service/remove/{eventId}";
    NSString *replaceeventId = [eventId description];
    if(replaceeventId)
        url_ = [url_ stringByReplacingOccurrencesOfString:@"{eventId}" withString:replaceeventId];
    return [[WebService getOperationManager] POST:url_
	            parameters:nil
	               success:^(NSURLSessionDataTask *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   Event* resp = [mapper mapObject:responseObject toClass:[Event class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(NSURLSessionDataTask*) CalendarAPI_CreateEvent:(Event*)event onSuccess:(void (^)(Event *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/calendar-service/create";
    return [[WebService getOperationManager] POST:url_
	            parameters:[event toDictionary]
	               success:^(NSURLSessionDataTask *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   Event* resp = [mapper mapObject:responseObject toClass:[Event class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(NSURLSessionDataTask*) CalendarAPI_ListUserEvents:(NSNumber*)startTime page:(NSNumber*)page onSuccess:(void (^)(EventList *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/calendar-service/list";
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    if(startTime) [dict setObject:startTime forKey:@"startTime"];
    if(page) [dict setObject:page forKey:@"page"];
    return [[WebService getOperationManager] GET:url_
	            parameters:dict
	               success:^(NSURLSessionDataTask *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   EventList* resp = [mapper mapObject:responseObject toClass:[EventList class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(NSURLSessionDataTask*) CalendarAPI_UpdateEvent:(Event*)event onSuccess:(void (^)(Event *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/calendar-service/update";
    return [[WebService getOperationManager] POST:url_
	            parameters:[event toDictionary]
	               success:^(NSURLSessionDataTask *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   Event* resp = [mapper mapObject:responseObject toClass:[Event class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(NSURLSessionDataTask*) CalendarAPI_RemoveAllEvents:(NSString*)parentEventId onSuccess:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/calendar-service/remove-all/{parentEventId}";
    NSString *replaceparentEventId = [parentEventId description];
    if(replaceparentEventId)
        url_ = [url_ stringByReplacingOccurrencesOfString:@"{parentEventId}" withString:replaceparentEventId];
    return [[WebService getOperationManager] POST:url_
	            parameters:nil
	               success:^(NSURLSessionDataTask *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   GenericResponse* resp = [mapper mapObject:responseObject toClass:[GenericResponse class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}


@end
