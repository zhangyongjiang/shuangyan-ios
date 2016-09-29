#import "AFHTTPRequestOperationManager.h"
#import "APIError.h"

typedef void (^OnRequestRetries)(AFHTTPRequestOperation* oldOperation, AFHTTPRequestOperation* newOperation);

@interface MyOperationManager : AFHTTPRequestOperationManager

- (void)setDefaultJsonRequestSerializer;
- (void)setAuthorizationToken;

- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        apiError:(void (^)(APIError* error))apiError;

- (AFHTTPRequestOperation*)GETWithRetries:(NSNumber*)retries
                                urlString:(NSString *)URLString
                               parameters:(id)parameters
                                  success:(void (^)(AFHTTPRequestOperation *, id))success
                                 apiError:(void (^)(APIError*))failure
                                  onRetry:(OnRequestRetries)onRetry;

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         apiError:(void (^)(APIError*error))apiError;

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
       constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        apiError:(void (^)(APIError* error))apiError;


- (AFHTTPRequestOperation *)DELETE:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        apiError:(void (^)(APIError* error))apiError;


- (AFHTTPRequestOperation*)downloadImage:(NSURL*)imageUrl
                                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)logError:(APIError*)error operation:(AFHTTPRequestOperation*)operation;

+(void)disableCacheForSeconds:(double)seconds;

@end

extern NSUInteger kDefaultMaxRetries;

