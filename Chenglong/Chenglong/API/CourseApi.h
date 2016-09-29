/*Auto generated file. Do not modify. Thu Sep 29 23:53:33 CST 2016 */

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "APIError.h"
#import "WebService.h"
#import "CourseList.h"
#import "Course.h"
#import "CourseDetails.h"

@interface CourseApi : NSObject

+(AFHTTPRequestOperation*) CourseAPI_Search:(NSString*)keywords page:(NSNumber*)page onSuccess:(void (^)(CourseList *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) CourseAPI_RemoveCourse:(NSString*)courseId onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) CourseAPI_GetCourse:(NSString*)courseId onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) CourseAPI_CreateCourseFileWithResources:(NSDictionary*)filePart json:(NSString*)json onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) CourseAPI_UpdateCourse:(Course*)course onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) CourseAPI_CreateCourseFile:(Course*)course onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) CourseAPI_ListUserCourses:(NSString*)userId courseId:(NSString*)courseId onSuccess:(void (^)(CourseDetails *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) CourseAPI_RemoveResources:(Course*)course onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) CourseAPI_AddResourceToCourse:(NSDictionary*)filePart courseId:(NSString*)courseId onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) CourseAPI_CreateCourseDir:(Course*)course onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock;


@end
