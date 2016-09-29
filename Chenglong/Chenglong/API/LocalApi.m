/*Auto generated file. Do not modify. Thu Sep 29 23:53:35 CST 2016 */

#import "LocalApi.h"
#import "ObjectMapper.h"

@implementation LocalApi

+(AFHTTPRequestOperation*) AdvertisingAPI_GetAdvertising:(NSString*)advertisingId onSuccess:(void (^)(Advertising *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/get/{advertisingId}";
    NSString *replaceadvertisingId = [advertisingId description];
    if(replaceadvertisingId)
        url_ = [url_ stringByReplacingOccurrencesOfString:@"{advertisingId}" withString:replaceadvertisingId];
    return [[WebService getOperationManager] GET:url_
	            parameters:nil
	               success:^(AFHTTPRequestOperation *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   Advertising* resp = [mapper mapObject:responseObject toClass:[Advertising class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(AFHTTPRequestOperation*) AdvertisingAPI_ListUserAdvertisings:(NSString*)keywords latitude:(NSNumber*)latitude longitude:(NSNumber*)longitude page:(NSNumber*)page onSuccess:(void (^)(AdvertisingList *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/search";
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
	                   AdvertisingList* resp = [mapper mapObject:responseObject toClass:[AdvertisingList class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(AFHTTPRequestOperation*) AdvertisingAPI_AddResourceToAdvertising:(NSDictionary*)filePart advertisingId:(NSString*)advertisingId onSuccess:(void (^)(Advertising *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/add-resource";
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    if(advertisingId) [dict setObject:advertisingId forKey:@"advertisingId"];
    return [WebService upload:filePart
	            parameters:dict
	            toPath:url_
	               success:^(AFHTTPRequestOperation *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   Advertising* resp = [mapper mapObject:responseObject toClass:[Advertising class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(AFHTTPRequestOperation*) AdvertisingAPI_CreateAdvertising:(NSDictionary*)filePart json:(NSString*)json onSuccess:(void (^)(Advertising *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/create";
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    if(json) [dict setObject:json forKey:@"json"];
    return [WebService upload:filePart
	            parameters:dict
	            toPath:url_
	               success:^(AFHTTPRequestOperation *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   Advertising* resp = [mapper mapObject:responseObject toClass:[Advertising class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(AFHTTPRequestOperation*) AdvertisingAPI_UpdateText:(Advertising*)advertising onSuccess:(void (^)(Advertising *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/update";
    return [[WebService getOperationManager] POST:url_
	            parameters:[advertising toDictionary]
	               success:^(AFHTTPRequestOperation *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   Advertising* resp = [mapper mapObject:responseObject toClass:[Advertising class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(AFHTTPRequestOperation*) AdvertisingAPI_RemoveResources:(Advertising*)advertising onSuccess:(void (^)(Advertising *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/remove-resource";
    return [[WebService getOperationManager] POST:url_
	            parameters:[advertising toDictionary]
	               success:^(AFHTTPRequestOperation *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   Advertising* resp = [mapper mapObject:responseObject toClass:[Advertising class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(AFHTTPRequestOperation*) AdvertisingAPI_RemoveAdvertising:(NSString*)advertisingId onSuccess:(void (^)(Advertising *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/remove/{advertisingId}";
    NSString *replaceadvertisingId = [advertisingId description];
    if(replaceadvertisingId)
        url_ = [url_ stringByReplacingOccurrencesOfString:@"{advertisingId}" withString:replaceadvertisingId];
    return [[WebService getOperationManager] POST:url_
	            parameters:nil
	               success:^(AFHTTPRequestOperation *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   Advertising* resp = [mapper mapObject:responseObject toClass:[Advertising class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(AFHTTPRequestOperation*) LocalAPI_ListUserBusinesss:(NSString*)keywords latitude:(NSNumber*)latitude longitude:(NSNumber*)longitude page:(NSNumber*)page onSuccess:(void (^)(BusinessList *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/search";
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
	                   BusinessList* resp = [mapper mapObject:responseObject toClass:[BusinessList class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(AFHTTPRequestOperation*) LocalAPI_CreateBusiness:(NSDictionary*)filePart json:(NSString*)json onSuccess:(void (^)(Business *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/create";
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    if(json) [dict setObject:json forKey:@"json"];
    return [WebService upload:filePart
	            parameters:dict
	            toPath:url_
	               success:^(AFHTTPRequestOperation *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   Business* resp = [mapper mapObject:responseObject toClass:[Business class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(AFHTTPRequestOperation*) LocalAPI_RemoveBusiness:(NSString*)businessId onSuccess:(void (^)(Business *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/remove/{businessId}";
    NSString *replacebusinessId = [businessId description];
    if(replacebusinessId)
        url_ = [url_ stringByReplacingOccurrencesOfString:@"{businessId}" withString:replacebusinessId];
    return [[WebService getOperationManager] POST:url_
	            parameters:nil
	               success:^(AFHTTPRequestOperation *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   Business* resp = [mapper mapObject:responseObject toClass:[Business class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(AFHTTPRequestOperation*) LocalAPI_UpdateText:(Business*)business onSuccess:(void (^)(Business *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/update";
    return [[WebService getOperationManager] POST:url_
	            parameters:[business toDictionary]
	               success:^(AFHTTPRequestOperation *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   Business* resp = [mapper mapObject:responseObject toClass:[Business class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(AFHTTPRequestOperation*) LocalAPI_RemoveResources:(Business*)business onSuccess:(void (^)(Business *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/remove-resource";
    return [[WebService getOperationManager] POST:url_
	            parameters:[business toDictionary]
	               success:^(AFHTTPRequestOperation *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   Business* resp = [mapper mapObject:responseObject toClass:[Business class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(AFHTTPRequestOperation*) LocalAPI_AddResourceToBusiness:(NSDictionary*)filePart businessId:(NSString*)businessId onSuccess:(void (^)(Business *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/add-resource";
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    if(businessId) [dict setObject:businessId forKey:@"businessId"];
    return [WebService upload:filePart
	            parameters:dict
	            toPath:url_
	               success:^(AFHTTPRequestOperation *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   Business* resp = [mapper mapObject:responseObject toClass:[Business class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(AFHTTPRequestOperation*) LocalAPI_GetBusiness:(NSString*)businessId onSuccess:(void (^)(Business *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/get/{businessId}";
    NSString *replacebusinessId = [businessId description];
    if(replacebusinessId)
        url_ = [url_ stringByReplacingOccurrencesOfString:@"{businessId}" withString:replacebusinessId];
    return [[WebService getOperationManager] GET:url_
	            parameters:nil
	               success:^(AFHTTPRequestOperation *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   Business* resp = [mapper mapObject:responseObject toClass:[Business class] withError:&error];
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
