/*Auto generated file. Do not modify. Tue Nov 29 16:01:14 CST 2016 */

#import "JournalApi.h"
#import "ObjectMapper.h"

@implementation JournalApi

+(NSURLSessionDataTask*) JournalAPI_RemoveResources:(Journal*)journal onSuccess:(void (^)(Journal *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/journal-service/remove-resource";
    return [[WebService getOperationManager] POST:url_
	            parameters:[journal toDictionary]
	               success:^(NSURLSessionDataTask *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   Journal* resp = [mapper mapObject:responseObject toClass:[Journal class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(NSURLSessionDataTask*) JournalAPI_ListUserJournals:(NSString*)userId page:(NSNumber*)page onSuccess:(void (^)(JournalDetailsList *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/journal-service/list";
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    if(userId) [dict setObject:userId forKey:@"userId"];
    if(page) [dict setObject:page forKey:@"page"];
    return [[WebService getOperationManager] GET:url_
	            parameters:dict
	               success:^(NSURLSessionDataTask *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   JournalDetailsList* resp = [mapper mapObject:responseObject toClass:[JournalDetailsList class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(NSURLSessionDataTask*) JournalAPI_RemoveJournal:(NSString*)journalId onSuccess:(void (^)(Journal *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/journal-service/remove/{journalId}";
    NSString *replacejournalId = [journalId description];
    if(replacejournalId)
        url_ = [url_ stringByReplacingOccurrencesOfString:@"{journalId}" withString:replacejournalId];
    return [[WebService getOperationManager] POST:url_
	            parameters:nil
	               success:^(NSURLSessionDataTask *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   Journal* resp = [mapper mapObject:responseObject toClass:[Journal class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(NSURLSessionDataTask*) JournalAPI_UpdateText:(Journal*)journal onSuccess:(void (^)(Journal *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/journal-service/update";
    return [[WebService getOperationManager] POST:url_
	            parameters:[journal toDictionary]
	               success:^(NSURLSessionDataTask *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   Journal* resp = [mapper mapObject:responseObject toClass:[Journal class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(NSURLSessionDataTask*) JournalAPI_GetJournal:(NSString*)journalId onSuccess:(void (^)(Journal *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/journal-service/get/{journalId}";
    NSString *replacejournalId = [journalId description];
    if(replacejournalId)
        url_ = [url_ stringByReplacingOccurrencesOfString:@"{journalId}" withString:replacejournalId];
    return [[WebService getOperationManager] GET:url_
	            parameters:nil
	               success:^(NSURLSessionDataTask *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   Journal* resp = [mapper mapObject:responseObject toClass:[Journal class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(NSURLSessionDataTask*) JournalAPI_CreateJournal:(NSDictionary*)filePart json:(NSString*)json onSuccess:(void (^)(Journal *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/journal-service/create";
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    if(json) [dict setObject:json forKey:@"json"];
    return [MyHTTPSessionManager upload:filePart parameters:nil toPath:url_ success:^(NSURLSessionDataTask *operation, id responseObject) {
        ObjectMapper *mapper = [ObjectMapper mapper];
        NSError *error;
        Journal* resp = [mapper mapObject:responseObject toClass:[Journal class] withError:&error];
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

+(NSURLSessionDataTask*) JournalAPI_AddResourceToJournal:(NSDictionary*)filePart journalId:(NSString*)journalId onSuccess:(void (^)(Journal *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/journal-service/add-resource";
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    if(journalId) [dict setObject:journalId forKey:@"journalId"];
    return [MyHTTPSessionManager upload:filePart parameters:nil toPath:url_ success:^(NSURLSessionDataTask *operation, id responseObject) {
        ObjectMapper *mapper = [ObjectMapper mapper];
        NSError *error;
        Journal* resp = [mapper mapObject:responseObject toClass:[Journal class] withError:&error];
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
