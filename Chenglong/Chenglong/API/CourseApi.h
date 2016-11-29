/*Auto generated file. Do not modify. Tue Nov 29 16:01:12 CST 2016 */

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "APIError.h"
#import "WebService.h"
#import "CourseList.h"
#import "Course.h"
#import "GenericResponse.h"
#import "CourseBuyRequest.h"
#import "CourseDetails.h"
#import "CourseInfo.h"
#import "CourseMoveRequest.h"
#import "RenameRequest.h"

@interface CourseApi : NSObject

+(AFHTTPRequestOperation*) CourseAPI_Search:(NSString*)keywords page:(NSNumber*)page onSuccess:(void (^)(CourseList *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) CourseAPI_CreateCourseFile:(Course*)course onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) CourseAPI_RemoveResources:(Course*)course onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) CourseAPI_RemoveCourse:(NSString*)courseId onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) CourseAPI_RemoveMyCourses:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) CourseAPI_RemoveAllCourses:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) CourseAPI_BuyCourse:(CourseBuyRequest*)req onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) CourseAPI_CreateCourseDir:(Course*)course onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) CourseAPI_GetCourseDetails:(NSString*)courseId onSuccess:(void (^)(CourseDetails *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) CourseAPI_GetCourse:(NSString*)courseId onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) CourseAPI_Unlike:(NSString*)courseId onSuccess:(void (^)(CourseInfo *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) CourseAPI_CreateCourseFileWithResources:(NSDictionary*)filePart json:(NSString*)json onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) CourseAPI_MoveCourse:(CourseMoveRequest*)req onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) CourseAPI_UpdateCourse:(Course*)course onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) CourseAPI_RenameCourse:(RenameRequest*)req onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) CourseAPI_Like:(NSString*)courseId onSuccess:(void (^)(CourseInfo *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) CourseAPI_ListCourses:(NSString*)courseId page:(NSNumber*)page onSuccess:(void (^)(CourseDetails *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) CourseAPI_ListUserCourses:(NSString*)userId page:(NSNumber*)page onSuccess:(void (^)(CourseDetails *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) CourseAPI_AddResourceToCourse:(NSDictionary*)filePart courseId:(NSString*)courseId onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock;


@end
