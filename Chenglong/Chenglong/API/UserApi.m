/*Auto generated file. Do not modify. Thu Sep 29 23:53:33 CST 2016 */

#import "UserApi.h"
#import "ObjectMapper.h"

@implementation UserApi

+(AFHTTPRequestOperation*) UserAPI_BlacklistFriend:(NSString*)friendId onSuccess:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/blacklist-friend/{friendId}";
    NSString *replacefriendId = [friendId description];
    if(replacefriendId)
        url_ = [url_ stringByReplacingOccurrencesOfString:@"{friendId}" withString:replacefriendId];
    return [[WebService getOperationManager] POST:url_
	            parameters:nil
	               success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

+(AFHTTPRequestOperation*) UserAPI_AcceptFriend:(NSString*)friendId onSuccess:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/accept-friend/{friendId}";
    NSString *replacefriendId = [friendId description];
    if(replacefriendId)
        url_ = [url_ stringByReplacingOccurrencesOfString:@"{friendId}" withString:replacefriendId];
    return [[WebService getOperationManager] POST:url_
	            parameters:nil
	               success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

+(AFHTTPRequestOperation*) UserAPI_RejectFriend:(NSString*)friendId onSuccess:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/reject-friend/{friendId}";
    NSString *replacefriendId = [friendId description];
    if(replacefriendId)
        url_ = [url_ stringByReplacingOccurrencesOfString:@"{friendId}" withString:replacefriendId];
    return [[WebService getOperationManager] POST:url_
	            parameters:nil
	               success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

+(AFHTTPRequestOperation*) UserAPI_UploadUserImage:(NSDictionary*)filePart onSuccess:(void (^)(MediaContent *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/upload-image";
    return [WebService upload:filePart
	            parameters:nil
	            toPath:url_
	               success:^(AFHTTPRequestOperation *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   MediaContent* resp = [mapper mapObject:responseObject toClass:[MediaContent class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(AFHTTPRequestOperation*) UserAPI_SendPhoneValidationCode:(PhoneRegisterRequest*)req onSuccess:(void (^)(User *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/send-phone-validation-code";
    return [[WebService getOperationManager] POST:url_
	            parameters:[req toDictionary]
	               success:^(AFHTTPRequestOperation *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   User* resp = [mapper mapObject:responseObject toClass:[User class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(AFHTTPRequestOperation*) UserAPI_RegisterByPhone:(PhoneRegisterRequest*)req onSuccess:(void (^)(User *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/register-by-phone";
    return [[WebService getOperationManager] POST:url_
	            parameters:[req toDictionary]
	               success:^(AFHTTPRequestOperation *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   User* resp = [mapper mapObject:responseObject toClass:[User class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(AFHTTPRequestOperation*) UserAPI_RegisterByEmail:(EmailRegisterRequest*)req onSuccess:(void (^)(User *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/register-by-email";
    return [[WebService getOperationManager] POST:url_
	            parameters:[req toDictionary]
	               success:^(AFHTTPRequestOperation *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   User* resp = [mapper mapObject:responseObject toClass:[User class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(AFHTTPRequestOperation*) UserAPI_ListFriends:(NSString*)userId page:(NSNumber*)page onSuccess:(void (^)(UserDetailsList *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/listFriends";
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    if(userId) [dict setObject:userId forKey:@"userId"];
    if(page) [dict setObject:page forKey:@"page"];
    return [[WebService getOperationManager] GET:url_
	            parameters:dict
	               success:^(AFHTTPRequestOperation *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   UserDetailsList* resp = [mapper mapObject:responseObject toClass:[UserDetailsList class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(AFHTTPRequestOperation*) UserAPI_Friend:(FriendRequest*)req onSuccess:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/friend";
    return [[WebService getOperationManager] POST:url_
	            parameters:[req toDictionary]
	               success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

+(AFHTTPRequestOperation*) UserAPI_Unfriend:(NSString*)friendId onSuccess:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/unfriend/{friendId}";
    NSString *replacefriendId = [friendId description];
    if(replacefriendId)
        url_ = [url_ stringByReplacingOccurrencesOfString:@"{friendId}" withString:replacefriendId];
    return [[WebService getOperationManager] POST:url_
	            parameters:nil
	               success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

+(AFHTTPRequestOperation*) UserAPI_Me:(void (^)(User *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/me";
    return [[WebService getOperationManager] GET:url_
	            parameters:nil
	               success:^(AFHTTPRequestOperation *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   User* resp = [mapper mapObject:responseObject toClass:[User class] withError:&error];
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
