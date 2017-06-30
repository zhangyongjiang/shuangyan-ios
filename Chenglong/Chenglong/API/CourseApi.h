/*Auto generated file. Do not modify. Tue Nov 29 16:01:12 CST 2016 */

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "APIError.h"
#import "WebService.h"
#import "CourseDetailsList.h"
#import "CourseList.h"
#import "Course.h"
#import "GenericResponse.h"
#import "CourseBuyRequest.h"
#import "CourseDetails.h"
#import "CourseDetailsWithParent.h"
#import "CourseInfo.h"
#import "CourseMoveRequest.h"
#import "RenameRequest.h"

@interface CourseApi : NSObject

+(NSURLSessionDataTask*) CourseAPI_Copy:(NSString*)srcId dstId:(NSString*)dstId onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) CourseAPI_Search:(NSString*)keywords age:(NSNumber*)age page:(NSNumber*)page onSuccess:(void (^)(CourseDetailsList *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) CourseAPI_CreateCourseFile:(Course*)course onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) CourseAPI_RemoveResources:(Course*)course onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) CourseAPI_RemoveCourse:(NSString*)courseId onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) CourseAPI_RemoveMyCourses:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) CourseAPI_RemoveAllCourses:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) CourseAPI_BuyCourse:(CourseBuyRequest*)req onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) CourseAPI_CreateCourseDir:(Course*)course onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) CourseAPI_GetCourseDetails:(NSString*)courseId onSuccess:(void (^)(CourseDetailsWithParent *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) CourseAPI_Unlike:(NSString*)courseId onSuccess:(void (^)(CourseInfo *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) CourseAPI_CreateCourseFileWithResources:(NSDictionary*)filePart json:(NSString*)json onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock progress:(void (^)(NSProgress *progress))progressBlock;

+(NSURLSessionDataTask*) CourseAPI_MoveCourse:(CourseMoveRequest*)req onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) CourseAPI_UpdateCourse:(Course*)course onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) CourseAPI_RenameCourse:(RenameRequest*)req onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) CourseAPI_Like:(NSString*)courseId onSuccess:(void (^)(CourseInfo *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) CourseAPI_ListUserCourses:(NSString*)userId currentDirId:(NSString*)currentDirId page:(NSNumber*)page onSuccess:(void (^)(CourseDetailsList *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) CourseAPI_AddResourceToCourse:(NSDictionary*)filePart courseId:(NSString*)courseId onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock progress:(void (^)(NSProgress *progress))progressBlock;


@end
