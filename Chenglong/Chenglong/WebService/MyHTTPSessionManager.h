#import "AFNetworking.h"
#import "APIError.h"
#import "Lockbox.h"
#import "Global.h"
#import "Lockbox.h"
#import "Config.h"

typedef void (^OnRequestRetries)(NSURLSessionDataTask* oldOperation, NSURLSessionDataTask* newOperation);

@interface MyHTTPSessionManager : AFHTTPSessionManager

- (void)setDefaultJsonRequestSerializer;
- (void)setAuthorizationToken;

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *operation, id responseObject))success
                     apiError:(void (^)(APIError* error))apiError;

- (NSURLSessionDataTask*)GETWithRetries:(NSNumber*)retries
                              urlString:(NSString *)URLString
                             parameters:(id)parameters
                                success:(void (^)(NSURLSessionDataTask *, id))success
                               apiError:(void (^)(APIError*))failure
                                onRetry:(OnRequestRetries)onRetry;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *operation, id responseObject))success
                      apiError:(void (^)(APIError*error))apiError;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                      progress:(void (^)(NSProgress *))uploadProgress
                       success:(void (^)(NSURLSessionDataTask *operation, id responseObject))success
                      apiError:(void (^)(APIError* error))apiError;


- (NSURLSessionDataTask *)DELETE:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(NSURLSessionDataTask *operation, id responseObject))success
                        apiError:(void (^)(APIError* error))apiError;

+(NSURLSessionDataTask*)upload:(NSDictionary*)dataDic
                    parameters:(NSDictionary*)parameters
                        toPath:(NSString*)path
                       success:(void (^)(NSURLSessionDataTask *operation, id responseObject))success
                      progress:(void (^)(NSProgress* progress))progress
                       failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure;

- (void)logError:(APIError*)error operation:(NSURLSessionDataTask*)operation;

+(void)disableCacheForSeconds:(double)seconds;

- (BOOL)newWorkachablity;

@end

extern NSUInteger kDefaultMaxRetries;

