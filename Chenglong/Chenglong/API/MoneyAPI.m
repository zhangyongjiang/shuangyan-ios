/*Auto generated file. Do not modify. Tue Jun 27 07:22:53 PDT 2017 */

#import "MoneyAPI.h"
#import "ObjectMapper.h"

@implementation MoneyAPI

+(NSURLSessionDataTask*) MoneyAPI_Spend:(MoneyRequest*)req onSuccess:(void (^)(MoneyFlow *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/user-service/money/spend";
    return [[WebService getOperationManager] POST:url_
	            parameters:[req toDictionary]
	               success:^(NSURLSessionDataTask *operation, id responseObject) {
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

+(NSURLSessionDataTask*) MoneyAPI_List:(NSNumber*)page onSuccess:(void (^)(MoneyFlowList *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/user-service/money/list";
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    if(page) [dict setObject:page forKey:@"page"];
    return [[WebService getOperationManager] GET:url_
	            parameters:dict
	               success:^(NSURLSessionDataTask *operation, id responseObject) {
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

+(NSURLSessionDataTask*) MoneyAPI_AddMoney:(MoneyRequest*)req onSuccess:(void (^)(MoneyFlow *resp))successBlock onError:(void (^)(APIError *err))errorBlock {
    NSString* url_ = @"/user-service/money/add";
    return [[WebService getOperationManager] POST:url_
	            parameters:[req toDictionary]
	               success:^(NSURLSessionDataTask *operation, id responseObject) {
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


@end
