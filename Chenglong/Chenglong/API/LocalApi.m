/*Auto generated file. Do not modify. Tue Nov 29 16:01:15 CST 2016 */

#import "LocalApi.h"
#import "ObjectMapper.h"

@implementation LocalApi

+(NSURLSessionDataTask*) AdvertisingAPI_AddResourceToAdvertising:(NSDictionary*)filePart advertisingId:(NSString*)advertisingId onSuccess:(void (^)(Advertising *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/zuul/local-service/ads/add-resource";
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    if(advertisingId) [dict setObject:advertisingId forKey:@"advertisingId"];
    return [MyHTTPSessionManager upload:filePart parameters:nil toPath:url_ success:^(NSURLSessionDataTask *operation, id responseObject) {
        ObjectMapper *mapper = [ObjectMapper mapper];
        NSError *error;
        Advertising* resp = [mapper mapObject:responseObject toClass:[Advertising class] withError:&error];
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

+(NSURLSessionDataTask*) AdvertisingAPI_CreateAdvertising:(NSDictionary*)filePart json:(NSString*)json onSuccess:(void (^)(Advertising *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/local-service/ads/create";
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    if(json) [dict setObject:json forKey:@"json"];
    return [MyHTTPSessionManager upload:filePart parameters:nil toPath:url_ success:^(NSURLSessionDataTask *operation, id responseObject) {
        ObjectMapper *mapper = [ObjectMapper mapper];
        NSError *error;
        Advertising* resp = [mapper mapObject:responseObject toClass:[Advertising class] withError:&error];
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

+(NSURLSessionDataTask*) AdvertisingAPI_RemoveResources:(Advertising*)advertising onSuccess:(void (^)(Advertising *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/local-service/ads/remove-resource";
    return [[WebService getOperationManager] POST:url_
	            parameters:[advertising toDictionary]
	               success:^(NSURLSessionDataTask *operation, id responseObject) {
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

+(NSURLSessionDataTask*) AdvertisingAPI_GetAdvertising:(NSString*)advertisingId onSuccess:(void (^)(Advertising *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/local-service/ads/get/{advertisingId}";
    NSString *replaceadvertisingId = [advertisingId description];
    if(replaceadvertisingId)
        url_ = [url_ stringByReplacingOccurrencesOfString:@"{advertisingId}" withString:replaceadvertisingId];
    return [[WebService getOperationManager] GET:url_
	            parameters:nil
	               success:^(NSURLSessionDataTask *operation, id responseObject) {
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

+(NSURLSessionDataTask*) AdvertisingAPI_ListUserAdvertisings:(NSString*)keywords latitude:(NSNumber*)latitude longitude:(NSNumber*)longitude page:(NSNumber*)page onSuccess:(void (^)(AdvertisingList *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/local-service/ads/search";
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    if(keywords) [dict setObject:keywords forKey:@"keywords"];
    if(latitude) [dict setObject:latitude forKey:@"latitude"];
    if(longitude) [dict setObject:longitude forKey:@"longitude"];
    if(page) [dict setObject:page forKey:@"page"];
    return [[WebService getOperationManager] GET:url_
	            parameters:dict
	               success:^(NSURLSessionDataTask *operation, id responseObject) {
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

+(NSURLSessionDataTask*) AdvertisingAPI_RemoveAdvertising:(NSString*)advertisingId onSuccess:(void (^)(Advertising *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/local-service/ads/remove/{advertisingId}";
    NSString *replaceadvertisingId = [advertisingId description];
    if(replaceadvertisingId)
        url_ = [url_ stringByReplacingOccurrencesOfString:@"{advertisingId}" withString:replaceadvertisingId];
    return [[WebService getOperationManager] POST:url_
	            parameters:nil
	               success:^(NSURLSessionDataTask *operation, id responseObject) {
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

+(NSURLSessionDataTask*) AdvertisingAPI_UpdateText:(Advertising*)advertising onSuccess:(void (^)(Advertising *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/local-service/ads/update";
    return [[WebService getOperationManager] POST:url_
	            parameters:[advertising toDictionary]
	               success:^(NSURLSessionDataTask *operation, id responseObject) {
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

+(NSURLSessionDataTask*) LocalAPI_RemoveResources:(Business*)business onSuccess:(void (^)(Business *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/local-service/local/remove-resource";
    return [[WebService getOperationManager] POST:url_
	            parameters:[business toDictionary]
	               success:^(NSURLSessionDataTask *operation, id responseObject) {
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

+(NSURLSessionDataTask*) LocalAPI_ListUserBusinesss:(NSString*)keywords latitude:(NSNumber*)latitude longitude:(NSNumber*)longitude page:(NSNumber*)page onSuccess:(void (^)(BusinessList *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/local-service/local/search";
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    if(keywords) [dict setObject:keywords forKey:@"keywords"];
    if(latitude) [dict setObject:latitude forKey:@"latitude"];
    if(longitude) [dict setObject:longitude forKey:@"longitude"];
    if(page) [dict setObject:page forKey:@"page"];
    return [[WebService getOperationManager] GET:url_
	            parameters:dict
	               success:^(NSURLSessionDataTask *operation, id responseObject) {
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

+(NSURLSessionDataTask*) LocalAPI_UpdateText:(Business*)business onSuccess:(void (^)(Business *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/local-service/local/update";
    return [[WebService getOperationManager] POST:url_
	            parameters:[business toDictionary]
	               success:^(NSURLSessionDataTask *operation, id responseObject) {
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

+(NSURLSessionDataTask*) LocalAPI_GetBusiness:(NSString*)businessId onSuccess:(void (^)(BusinessDetails *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/local-service/local/get/{businessId}";
    NSString *replacebusinessId = [businessId description];
    if(replacebusinessId)
        url_ = [url_ stringByReplacingOccurrencesOfString:@"{businessId}" withString:replacebusinessId];
    return [[WebService getOperationManager] GET:url_
	            parameters:nil
	               success:^(NSURLSessionDataTask *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   BusinessDetails* resp = [mapper mapObject:responseObject toClass:[BusinessDetails class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(NSURLSessionDataTask*) LocalAPI_RemoveReview:(NSString*)reviewId onSuccess:(void (^)(BusinessSummary *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/local-service/local/remove-review/{reviewId}";
    NSString *replacereviewId = [reviewId description];
    if(replacereviewId)
        url_ = [url_ stringByReplacingOccurrencesOfString:@"{reviewId}" withString:replacereviewId];
    return [[WebService getOperationManager] POST:url_
	            parameters:nil
	               success:^(NSURLSessionDataTask *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   BusinessSummary* resp = [mapper mapObject:responseObject toClass:[BusinessSummary class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(NSURLSessionDataTask*) LocalAPI_Review:(BusinessReview*)review onSuccess:(void (^)(BusinessSummary *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/local-service/local/review";
    return [[WebService getOperationManager] POST:url_
	            parameters:[review toDictionary]
	               success:^(NSURLSessionDataTask *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   BusinessSummary* resp = [mapper mapObject:responseObject toClass:[BusinessSummary class] withError:&error];
	                   if (error) {
	                       errorBlock([[APIError alloc] initWithOperation:operation andError:error]);
	                   } else { 
	                       successBlock(resp);
	                   }
	               } apiError:^(APIError* error) {
	                   errorBlock(error);
	               }];
}

+(NSURLSessionDataTask*) LocalAPI_CreateBusiness:(NSDictionary*)filePart json:(NSString*)json onSuccess:(void (^)(Business *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/local-service/local/create";
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    if(json) [dict setObject:json forKey:@"json"];
    return [MyHTTPSessionManager upload:filePart parameters:nil toPath:url_ success:^(NSURLSessionDataTask *operation, id responseObject) {
        ObjectMapper *mapper = [ObjectMapper mapper];
        NSError *error;
        Business* resp = [mapper mapObject:responseObject toClass:[Business class] withError:&error];
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

+(NSURLSessionDataTask*) LocalAPI_AddResourceToBusiness:(NSDictionary*)filePart businessId:(NSString*)businessId onSuccess:(void (^)(Business *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/local-service/local/add-resource";
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    if(businessId) [dict setObject:businessId forKey:@"businessId"];
    return [MyHTTPSessionManager upload:filePart parameters:nil toPath:url_ success:^(NSURLSessionDataTask *operation, id responseObject) {
        ObjectMapper *mapper = [ObjectMapper mapper];
        NSError *error;
        Business* resp = [mapper mapObject:responseObject toClass:[Business class] withError:&error];
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

+(NSURLSessionDataTask*) LocalAPI_RemoveBusiness:(NSString*)businessId onSuccess:(void (^)(Business *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/local-service/local/remove/{businessId}";
    NSString *replacebusinessId = [businessId description];
    if(replacebusinessId)
        url_ = [url_ stringByReplacingOccurrencesOfString:@"{businessId}" withString:replacebusinessId];
    return [[WebService getOperationManager] POST:url_
	            parameters:nil
	               success:^(NSURLSessionDataTask *operation, id responseObject) {
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

+(NSURLSessionDataTask*) LocalAPI_ListBusinesssReviews:(NSString*)businessId page:(NSNumber*)page onSuccess:(void (^)(BusinessReviewList *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/local-service/local/list-reviews";
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    if(businessId) [dict setObject:businessId forKey:@"businessId"];
    if(page) [dict setObject:page forKey:@"page"];
    return [[WebService getOperationManager] GET:url_
	            parameters:dict
	               success:^(NSURLSessionDataTask *operation, id responseObject) {
	                   ObjectMapper *mapper = [ObjectMapper mapper];
	                   NSError *error;
	                   BusinessReviewList* resp = [mapper mapObject:responseObject toClass:[BusinessReviewList class] withError:&error];
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
