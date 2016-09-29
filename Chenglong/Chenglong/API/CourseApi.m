/*Auto generated file. Do not modify. Thu Sep 29 23:53:33 CST 2016 */

#import "CourseApi.h"
#import "ObjectMapper.h"

@implementation CourseApi

+(AFHTTPRequestOperation*) CourseAPI_Search:(NSString*)keywords page:(NSNumber*)page onSuccess:(void (^)(CourseList *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/search";
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    if(keywords) [dict setObject:keywords forKey:@"keywords"];
    if(page) [dict setObject:page forKey:@"page"];
    return [[WebService getOperationManager] GET:url_
	            parameters:dict
	               success:^(AFHTTPRequestOperation *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   CourseList* resp = [mapper mapObject:responseObject toClass:[CourseList class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(AFHTTPRequestOperation*) CourseAPI_RemoveCourse:(NSString*)courseId onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/remove/{courseId}";
    NSString *replacecourseId = [courseId description];
    if(replacecourseId)
        url_ = [url_ stringByReplacingOccurrencesOfString:@"{courseId}" withString:replacecourseId];
    return [[WebService getOperationManager] POST:url_
	            parameters:nil
	               success:^(AFHTTPRequestOperation *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   Course* resp = [mapper mapObject:responseObject toClass:[Course class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(AFHTTPRequestOperation*) CourseAPI_GetCourse:(NSString*)courseId onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/get/{courseId}";
    NSString *replacecourseId = [courseId description];
    if(replacecourseId)
        url_ = [url_ stringByReplacingOccurrencesOfString:@"{courseId}" withString:replacecourseId];
    return [[WebService getOperationManager] GET:url_
	            parameters:nil
	               success:^(AFHTTPRequestOperation *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   Course* resp = [mapper mapObject:responseObject toClass:[Course class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(AFHTTPRequestOperation*) CourseAPI_CreateCourseFileWithResources:(NSDictionary*)filePart json:(NSString*)json onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/create-file-with-resources";
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    if(json) [dict setObject:json forKey:@"json"];
    return [WebService upload:filePart
	            parameters:dict
	            toPath:url_
	               success:^(AFHTTPRequestOperation *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   Course* resp = [mapper mapObject:responseObject toClass:[Course class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(AFHTTPRequestOperation*) CourseAPI_UpdateCourse:(Course*)course onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/update";
    return [[WebService getOperationManager] POST:url_
	            parameters:[course toDictionary]
	               success:^(AFHTTPRequestOperation *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   Course* resp = [mapper mapObject:responseObject toClass:[Course class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(AFHTTPRequestOperation*) CourseAPI_CreateCourseFile:(Course*)course onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/create-file";
    return [[WebService getOperationManager] POST:url_
	            parameters:[course toDictionary]
	               success:^(AFHTTPRequestOperation *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   Course* resp = [mapper mapObject:responseObject toClass:[Course class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(AFHTTPRequestOperation*) CourseAPI_ListUserCourses:(NSString*)userId courseId:(NSString*)courseId onSuccess:(void (^)(CourseDetails *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/list";
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    if(userId) [dict setObject:userId forKey:@"userId"];
    if(courseId) [dict setObject:courseId forKey:@"courseId"];
    return [[WebService getOperationManager] GET:url_
	            parameters:dict
	               success:^(AFHTTPRequestOperation *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   CourseDetails* resp = [mapper mapObject:responseObject toClass:[CourseDetails class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(AFHTTPRequestOperation*) CourseAPI_RemoveResources:(Course*)course onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/remove-resource";
    return [[WebService getOperationManager] POST:url_
	            parameters:[course toDictionary]
	               success:^(AFHTTPRequestOperation *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   Course* resp = [mapper mapObject:responseObject toClass:[Course class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(AFHTTPRequestOperation*) CourseAPI_AddResourceToCourse:(NSDictionary*)filePart courseId:(NSString*)courseId onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/add-resource";
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    if(courseId) [dict setObject:courseId forKey:@"courseId"];
    return [WebService upload:filePart
	            parameters:dict
	            toPath:url_
	               success:^(AFHTTPRequestOperation *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   Course* resp = [mapper mapObject:responseObject toClass:[Course class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(AFHTTPRequestOperation*) CourseAPI_CreateCourseDir:(Course*)course onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/create-dir";
    return [[WebService getOperationManager] POST:url_
	            parameters:[course toDictionary]
	               success:^(AFHTTPRequestOperation *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   Course* resp = [mapper mapObject:responseObject toClass:[Course class] withError:&error];
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
