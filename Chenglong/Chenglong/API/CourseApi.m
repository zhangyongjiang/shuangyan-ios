/*Auto generated file. Do not modify. Tue Nov 29 16:01:12 CST 2016 */

#import "CourseApi.h"
#import "ObjectMapper.h"

@implementation CourseApi

+(NSURLSessionDataTask*) CourseAPI_Search:(NSString*)keywords age:(NSNumber*)age page:(NSNumber*)page onSuccess:(void (^)(CourseDetailsList *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/course-service/search";
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    if(keywords) [dict setObject:keywords forKey:@"keywords"];
    if(page) [dict setObject:page forKey:@"page"];
    if(age) [dict setObject:age forKey:@"age"];
    return [[WebService getOperationManager] GET:url_
	            parameters:dict
	               success:^(NSURLSessionDataTask *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   CourseDetailsList* resp = [mapper mapObject:responseObject toClass:[CourseDetailsList class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(NSURLSessionDataTask*) CourseAPI_CreateCourseFile:(Course*)course onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/course-service/create-file";
    return [[WebService getOperationManager] POST:url_
	            parameters:[course toDictionary]
	               success:^(NSURLSessionDataTask *operation, id responseObject) {
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

+(NSURLSessionDataTask*) CourseAPI_RemoveResources:(Course*)course onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/course-service/remove-resource";
    return [[WebService getOperationManager] POST:url_
	            parameters:[course toDictionary]
	               success:^(NSURLSessionDataTask *operation, id responseObject) {
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

+(NSURLSessionDataTask*) CourseAPI_RemoveCourse:(NSString*)courseId onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/course-service/remove/{courseId}";
    NSString *replacecourseId = [courseId description];
    if(replacecourseId)
        url_ = [url_ stringByReplacingOccurrencesOfString:@"{courseId}" withString:replacecourseId];
    return [[WebService getOperationManager] POST:url_
	            parameters:nil
	               success:^(NSURLSessionDataTask *operation, id responseObject) {
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

+(NSURLSessionDataTask*) CourseAPI_RemoveMyCourses:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/course-service/remove-my-courses";
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

+(NSURLSessionDataTask*) CourseAPI_RemoveAllCourses:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/course-service/remove-all";
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

+(NSURLSessionDataTask*) CourseAPI_BuyCourse:(CourseBuyRequest*)req onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/course-service/buy";
    return [[WebService getOperationManager] POST:url_
	            parameters:[req toDictionary]
	               success:^(NSURLSessionDataTask *operation, id responseObject) {
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

+(NSURLSessionDataTask*) CourseAPI_CreateCourseDir:(Course*)course onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/course-service/create-dir";
    return [[WebService getOperationManager] POST:url_
	            parameters:[course toDictionary]
	               success:^(NSURLSessionDataTask *operation, id responseObject) {
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

+(NSURLSessionDataTask*) CourseAPI_GetCourseDetails:(NSString*)courseId onSuccess:(void (^)(CourseDetails *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/course-service/get-details/{courseId}";
    NSString *replacecourseId = [courseId description];
    if(replacecourseId)
        url_ = [url_ stringByReplacingOccurrencesOfString:@"{courseId}" withString:replacecourseId];
    return [[WebService getOperationManager] GET:url_
	            parameters:nil
	               success:^(NSURLSessionDataTask *operation, id responseObject) {
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

+(NSURLSessionDataTask*) CourseAPI_Unlike:(NSString*)courseId onSuccess:(void (^)(CourseInfo *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/course-service/unlike/{courseId}";
    NSString *replacecourseId = [courseId description];
    if(replacecourseId)
        url_ = [url_ stringByReplacingOccurrencesOfString:@"{courseId}" withString:replacecourseId];
    return [[WebService getOperationManager] POST:url_
	            parameters:nil
	               success:^(NSURLSessionDataTask *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   CourseInfo* resp = [mapper mapObject:responseObject toClass:[CourseInfo class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(NSURLSessionDataTask*) CourseAPI_CreateCourseFileWithResources:(NSDictionary*)filePart json:(NSString*)json onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/zuul/course-service/create-file-with-resources";
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    if(json) [dict setObject:json forKey:@"json"];
    return [MyHTTPSessionManager upload:filePart parameters:dict toPath:url_ success:^(NSURLSessionDataTask *operation, id responseObject) {
        ObjectMapper *mapper = [ObjectMapper mapper];
        NSError *error;
        Course* resp = [mapper mapObject:responseObject toClass:[Course class] withError:&error];
        if (error) {
            errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
        } else {
            successBlock(resp);
        }
    } progress:^(NSProgress *progress) {
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
    }];
}

+(NSURLSessionDataTask*) CourseAPI_MoveCourse:(CourseMoveRequest*)req onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/course-service/move";
    return [[WebService getOperationManager] POST:url_
	            parameters:[req toDictionary]
	               success:^(NSURLSessionDataTask *operation, id responseObject) {
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

+(NSURLSessionDataTask*) CourseAPI_UpdateCourse:(Course*)course onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/course-service/update";
    return [[WebService getOperationManager] POST:url_
	            parameters:[course toDictionary]
	               success:^(NSURLSessionDataTask *operation, id responseObject) {
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

+(NSURLSessionDataTask*) CourseAPI_RenameCourse:(RenameRequest*)req onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/course-service/rename";
    return [[WebService getOperationManager] POST:url_
	            parameters:[req toDictionary]
	               success:^(NSURLSessionDataTask *operation, id responseObject) {
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

+(NSURLSessionDataTask*) CourseAPI_Like:(NSString*)courseId onSuccess:(void (^)(CourseInfo *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/course-service/like/{courseId}";
    NSString *replacecourseId = [courseId description];
    if(replacecourseId)
        url_ = [url_ stringByReplacingOccurrencesOfString:@"{courseId}" withString:replacecourseId];
    return [[WebService getOperationManager] POST:url_
	            parameters:nil
	               success:^(NSURLSessionDataTask *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   CourseInfo* resp = [mapper mapObject:responseObject toClass:[CourseInfo class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(NSURLSessionDataTask*) CourseAPI_ListUserCourses:(NSString*)userId page:(NSNumber*)page onSuccess:(void (^)(CourseDetails *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/course-service/list-user-courses";
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    if(userId) [dict setObject:userId forKey:@"userId"];
    if(page) [dict setObject:page forKey:@"page"];
    return [[WebService getOperationManager] GET:url_
	            parameters:dict
	               success:^(NSURLSessionDataTask *operation, id responseObject) {
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

+(NSURLSessionDataTask*) CourseAPI_AddResourceToCourse:(NSDictionary*)filePart courseId:(NSString*)courseId onSuccess:(void (^)(Course *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/zuul/course-service/add-resource";
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    if(courseId) [dict setObject:courseId forKey:@"courseId"];
    return [MyHTTPSessionManager upload:filePart parameters:dict toPath:url_ success:^(NSURLSessionDataTask *operation, id responseObject) {
        ObjectMapper *mapper = [ObjectMapper mapper];
        NSError *error;
        Course* resp = [mapper mapObject:responseObject toClass:[Course class] withError:&error];
        if (error) {
            errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
        } else {
            successBlock(resp);
        }
    } progress:^(NSProgress *progress) {
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
    }];
}


@end
