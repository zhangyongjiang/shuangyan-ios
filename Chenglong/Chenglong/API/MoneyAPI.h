/*Auto generated file. Do not modify. Tue Jun 27 07:22:53 PDT 2017 */

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "APIError.h"
#import "WebService.h"
#import "MoneyFlow.h"
#import "MoneyRequest.h"
#import "MoneyFlowList.h"

@interface MoneyAPI : NSObject

+(NSURLSessionDataTask*) MoneyAPI_Spend:(MoneyRequest*)req onSuccess:(void (^)(MoneyFlow *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) MoneyAPI_List:(NSNumber*)page onSuccess:(void (^)(MoneyFlowList *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) MoneyAPI_AddMoney:(MoneyRequest*)req onSuccess:(void (^)(MoneyFlow *resp))successBlock onError:(void (^)(APIError *err))errorBlock;


@end
