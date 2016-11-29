/*Auto generated file. Do not modify. Tue Nov 29 16:01:15 CST 2016 */

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "APIError.h"
#import "WebService.h"
#import "Advertising.h"
#import "AdvertisingList.h"
#import "Business.h"
#import "BusinessList.h"
#import "BusinessDetails.h"
#import "BusinessSummary.h"
#import "BusinessReview.h"
#import "BusinessReviewList.h"

@interface LocalApi : NSObject

+(AFHTTPRequestOperation*) AdvertisingAPI_AddResourceToAdvertising:(NSDictionary*)filePart advertisingId:(NSString*)advertisingId onSuccess:(void (^)(Advertising *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) AdvertisingAPI_CreateAdvertising:(NSDictionary*)filePart json:(NSString*)json onSuccess:(void (^)(Advertising *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) AdvertisingAPI_RemoveResources:(Advertising*)advertising onSuccess:(void (^)(Advertising *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) AdvertisingAPI_GetAdvertising:(NSString*)advertisingId onSuccess:(void (^)(Advertising *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) AdvertisingAPI_ListUserAdvertisings:(NSString*)keywords latitude:(NSNumber*)latitude longitude:(NSNumber*)longitude page:(NSNumber*)page onSuccess:(void (^)(AdvertisingList *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) AdvertisingAPI_RemoveAdvertising:(NSString*)advertisingId onSuccess:(void (^)(Advertising *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) AdvertisingAPI_UpdateText:(Advertising*)advertising onSuccess:(void (^)(Advertising *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) LocalAPI_RemoveResources:(Business*)business onSuccess:(void (^)(Business *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) LocalAPI_ListUserBusinesss:(NSString*)keywords latitude:(NSNumber*)latitude longitude:(NSNumber*)longitude page:(NSNumber*)page onSuccess:(void (^)(BusinessList *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) LocalAPI_UpdateText:(Business*)business onSuccess:(void (^)(Business *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) LocalAPI_GetBusiness:(NSString*)businessId onSuccess:(void (^)(BusinessDetails *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) LocalAPI_RemoveReview:(NSString*)reviewId onSuccess:(void (^)(BusinessSummary *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) LocalAPI_Review:(BusinessReview*)review onSuccess:(void (^)(BusinessSummary *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) LocalAPI_CreateBusiness:(NSDictionary*)filePart json:(NSString*)json onSuccess:(void (^)(Business *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) LocalAPI_AddResourceToBusiness:(NSDictionary*)filePart businessId:(NSString*)businessId onSuccess:(void (^)(Business *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) LocalAPI_RemoveBusiness:(NSString*)businessId onSuccess:(void (^)(Business *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) LocalAPI_ListBusinesssReviews:(NSString*)businessId page:(NSNumber*)page onSuccess:(void (^)(BusinessReviewList *resp))successBlock onError:(void (^)(APIError *err))errorBlock;


@end
