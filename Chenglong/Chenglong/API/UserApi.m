/*Auto generated file. Do not modify. Tue Nov 29 16:01:08 CST 2016 */

#import "UserApi.h"
#import "ObjectMapper.h"

@implementation UserApi

+(AFHTTPRequestOperation*) MoneyAPI_Spend:(MoneyRequest*)req onSuccess:(void (^)(MoneyFlow *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/user-service/money/spend";
    return [[WebService getOperationManager] POST:url_
	            parameters:[req toDictionary]
	               success:^(AFHTTPRequestOperation *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   MoneyFlow* resp = [mapper mapObject:responseObject toClass:[MoneyFlow class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(AFHTTPRequestOperation*) MoneyAPI_ListFriends:(NSNumber*)page onSuccess:(void (^)(MoneyFlowList *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/user-service/money/list";
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    if(page) [dict setObject:page forKey:@"page"];
    return [[WebService getOperationManager] GET:url_
	            parameters:dict
	               success:^(AFHTTPRequestOperation *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   MoneyFlowList* resp = [mapper mapObject:responseObject toClass:[MoneyFlowList class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(AFHTTPRequestOperation*) MoneyAPI_AddMoney:(MoneyRequest*)req onSuccess:(void (^)(MoneyFlow *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/user-service/money/add";
    return [[WebService getOperationManager] POST:url_
	            parameters:[req toDictionary]
	               success:^(AFHTTPRequestOperation *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   MoneyFlow* resp = [mapper mapObject:responseObject toClass:[MoneyFlow class] withError:&error];
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
    NSString* url_ = @"/user-service/user/me";
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

+(AFHTTPRequestOperation*) UserAPI_ListFriends:(NSString*)userId page:(NSNumber*)page onSuccess:(void (^)(UserDetailsList *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/user-service/user/listFriends";
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

+(AFHTTPRequestOperation*) UserAPI_GetUser:(NSString*)userId onSuccess:(void (^)(User *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/user-service/user/{userId}";
    NSString *replaceuserId = [userId description];
    if(replaceuserId)
        url_ = [url_ stringByReplacingOccurrencesOfString:@"{userId}" withString:replaceuserId];
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

+(AFHTTPRequestOperation*) UserAPI_RegisterByEmail:(EmailRegisterRequest*)req onSuccess:(void (^)(User *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/user-service/user/register-by-email";
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
    NSString* url_ = @"/user-service/user/register-by-phone";
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

+(AFHTTPRequestOperation*) UserAPI_SendPhoneValidationCode:(PhoneRegisterRequest*)req onSuccess:(void (^)(User *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/user-service/user/send-phone-validation-code";
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

+(AFHTTPRequestOperation*) UserAPI_UploadUserImage:(NSDictionary*)filePart onSuccess:(void (^)(MediaContent *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/user-service/user/upload-image";
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

+(AFHTTPRequestOperation*) UserAPI_Friend:(FriendRequest*)req onSuccess:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/user-service/user/friend";
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

+(AFHTTPRequestOperation*) UserAPI_AcceptFriend:(NSString*)friendId onSuccess:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/user-service/user/accept-friend/{friendId}";
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

+(AFHTTPRequestOperation*) UserAPI_Unfriend:(NSString*)friendId onSuccess:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/user-service/user/unfriend/{friendId}";
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
    NSString* url_ = @"/user-service/user/reject-friend/{friendId}";
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

+(AFHTTPRequestOperation*) UserAPI_BlacklistFriend:(NSString*)friendId onSuccess:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/user-service/user/blacklist-friend/{friendId}";
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

+(AFHTTPRequestOperation*) UserAPI_WechatRegisterUser:(WechatLoginRequest*)req onSuccess:(void (^)(User *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/user-service/user/wechat-login";
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

+(AFHTTPRequestOperation*) UserAPI_PhoneLogin:(PhoneLoginRequest*)req onSuccess:(void (^)(User *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/user-service/user/phone-login";
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

+(AFHTTPRequestOperation*) UserAPI_ChangePassword:(ChangePasswordRequest*)req onSuccess:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/user-service/user/change-password";
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

+(AFHTTPRequestOperation*) UserAPI_ResetPassword:(ResetPasswordRequest*)req onSuccess:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/user-service/user/reset-password";
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

+(AFHTTPRequestOperation*) UserAPI_RemoveUser:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/user-service/user/remove-me";
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

+(AFHTTPRequestOperation*) UserAPI_Interest:(NSString*)type targetType:(NSString*)targetType targetId:(NSString*)targetId onSuccess:(void (^)(UserInterest *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/user-service/user/interest/{type}/{targetType}/{targetId}";
    NSString *replacetype = [type description];
    if(replacetype)
        url_ = [url_ stringByReplacingOccurrencesOfString:@"{type}" withString:replacetype];
    NSString *replacetargetType = [targetType description];
    if(replacetargetType)
        url_ = [url_ stringByReplacingOccurrencesOfString:@"{targetType}" withString:replacetargetType];
    NSString *replacetargetId = [targetId description];
    if(replacetargetId)
        url_ = [url_ stringByReplacingOccurrencesOfString:@"{targetId}" withString:replacetargetId];
    return [[WebService getOperationManager] POST:url_
	            parameters:nil
	               success:^(AFHTTPRequestOperation *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   UserInterest* resp = [mapper mapObject:responseObject toClass:[UserInterest class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(AFHTTPRequestOperation*) UserAPI_GetInterest:(NSString*)type targetType:(NSString*)targetType targetId:(NSString*)targetId onSuccess:(void (^)(UserInterest *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/user-service/user/interest/{type}/{targetType}/{targetId}";
    NSString *replacetype = [type description];
    if(replacetype)
        url_ = [url_ stringByReplacingOccurrencesOfString:@"{type}" withString:replacetype];
    NSString *replacetargetType = [targetType description];
    if(replacetargetType)
        url_ = [url_ stringByReplacingOccurrencesOfString:@"{targetType}" withString:replacetargetType];
    NSString *replacetargetId = [targetId description];
    if(replacetargetId)
        url_ = [url_ stringByReplacingOccurrencesOfString:@"{targetId}" withString:replacetargetId];
    return [[WebService getOperationManager] GET:url_
	            parameters:nil
	               success:^(AFHTTPRequestOperation *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   UserInterest* resp = [mapper mapObject:responseObject toClass:[UserInterest class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(AFHTTPRequestOperation*) UserAPI_Uninterest:(NSString*)type targetType:(NSString*)targetType targetId:(NSString*)targetId onSuccess:(void (^)(UserInterest *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/user-service/user/uninterest/{type}/{targetType}/{targetId}";
    NSString *replacetype = [type description];
    if(replacetype)
        url_ = [url_ stringByReplacingOccurrencesOfString:@"{type}" withString:replacetype];
    NSString *replacetargetType = [targetType description];
    if(replacetargetType)
        url_ = [url_ stringByReplacingOccurrencesOfString:@"{targetType}" withString:replacetargetType];
    NSString *replacetargetId = [targetId description];
    if(replacetargetId)
        url_ = [url_ stringByReplacingOccurrencesOfString:@"{targetId}" withString:replacetargetId];
    return [[WebService getOperationManager] POST:url_
	            parameters:nil
	               success:^(AFHTTPRequestOperation *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   UserInterest* resp = [mapper mapObject:responseObject toClass:[UserInterest class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(AFHTTPRequestOperation*) UserAPI_ListUserBusinesss:(NSString*)keywords latitude:(NSNumber*)latitude longitude:(NSNumber*)longitude page:(NSNumber*)page onSuccess:(void (^)(UserList *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/user-service/user/search";
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    if(keywords) [dict setObject:keywords forKey:@"keywords"];
    if(latitude) [dict setObject:latitude forKey:@"latitude"];
    if(longitude) [dict setObject:longitude forKey:@"longitude"];
    if(page) [dict setObject:page forKey:@"page"];
    return [[WebService getOperationManager] GET:url_
	            parameters:dict
	               success:^(AFHTTPRequestOperation *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   UserList* resp = [mapper mapObject:responseObject toClass:[UserList class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(AFHTTPRequestOperation*) UserAPI_Invite:(InviteRequest*)req onSuccess:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/user-service/user/invite";
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

+(AFHTTPRequestOperation*) UserAPI_RemoveAllUsers:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/user-service/user/remove-all-users";
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


@end
