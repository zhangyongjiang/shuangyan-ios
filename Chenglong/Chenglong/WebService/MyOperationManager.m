#import "MyOperationManager.h"
#import "Global.h"
#import "Config.h"

static double nocacheTillSecond = 0;
static double kDefaultRequestTimeOutInSecs = 30;
static double kRetryRequestTimeOutInSecs = 10;

NSUInteger kDefaultMaxRetries = 3;

@implementation MyOperationManager

+(void)load {
}


+(void)disableCacheForSeconds:(double)seconds {
    nocacheTillSecond = CFAbsoluteTimeGetCurrent() + seconds;
    NSLog(@"disable cache till %f", (double)nocacheTillSecond);
}


+(BOOL)isCacheDisabled {
    return CFAbsoluteTimeGetCurrent() < nocacheTillSecond;
}


- (NSString *)getKeyWithParemeters:(id)parameters withUrlString:(NSString *)URLString
{
    return [[NSString stringWithFormat:@"%@?%@",URLString,parameters] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
}


- (void)setDefaultJsonRequestSerializer {

    NSString* UUID = [[NSUUID UUID] UUIDString];
    
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    self.requestSerializer.timeoutInterval = kDefaultRequestTimeOutInSecs;
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self.requestSerializer setValue:UUID forHTTPHeaderField:@"reqid"];
}


- (void)setAuthorizationToken {
//    NSString* token = [Lockbox stringForKey:kOauthTokenKey];
//
//    if ( token.length > 0 ) {
//        [self.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
//    } else {
//        [self.requestSerializer setValue:@"" forHTTPHeaderField:@"Authorization"];
//    }
}


- (void)logError:(APIError*)error operation:(AFHTTPRequestOperation*)operation {
#ifdef LOG_API_ERRORS
    if ( error.rawError.code == NSURLErrorTimedOut ) {
        NSString* url = [operation.request.URL absoluteString];
        NSString* reqid = operation.request.allHTTPHeaderFields[@"reqid"];
    }
    
#endif
}

- (AFHTTPRequestOperation*)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *, id))success apiError:(void (^)(APIError*))failure
{
    [self setDefaultJsonRequestSerializer];
    [self setAuthorizationToken];
    
//    NSLog(@"GET: %@ with data: %@", URLString, parameters);
    AFHTTPRequestOperation *operation = [super GET:URLString parameters:parameters
                                           success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                                               NSLog(@"GET SUCCESS: %@ with data: %@", URLString, parameters);
                                               success(operation, responseObject);
                                           }
                                           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                                               NSLog(@"GET ERROR: %@ with data: %@. %@", URLString, parameters, error);
                                               APIError* apiError = [[APIError alloc] initWithOperation:operation andError:error];
                                               failure(apiError);
                                               [self logError:apiError operation:operation];
                                           }];
    
    return operation;
}


- (AFHTTPRequestOperation*)GETWithRetries:(NSNumber*)retries urlString:(NSString *)URLString parameters:(id)parameters
                                  success:(void (^)(AFHTTPRequestOperation *, id))success
                                 apiError:(void (^)(APIError*))failure
                                  onRetry:(OnRequestRetries)onRetry
{
     MyOperationManager* __weak weakSelf = self;
    
    [self setDefaultJsonRequestSerializer];
    [self setAuthorizationToken];
    
    self.requestSerializer.timeoutInterval = kRetryRequestTimeOutInSecs;
    
//    NSLog(@"GET: %@ with data: %@", URLString, parameters);
    AFHTTPRequestOperation *operation = [super GET:URLString parameters:parameters
                                           success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                                               NSLog(@"GET SUCCESS: %@ with data: %@", URLString, parameters);
                                               success(operation, responseObject);
                                           }
                                           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                               NSUInteger retriesRemaining = retries.integerValue - 1;
                                               if ( error != nil && error.code ==  NSURLErrorTimedOut && retriesRemaining > 0 ) {
                                                   NSLog(@"Retrying #%lu: %@", kDefaultMaxRetries - retriesRemaining, URLString);
                                                   AFHTTPRequestOperation* newOperation = [weakSelf GETWithRetries:@(retriesRemaining) urlString:URLString parameters:parameters success:success apiError:failure onRetry:onRetry];
                                                   if ( onRetry != nil ) {
                                                       onRetry(operation, newOperation);
                                                   }
                                               } else {
//                                                   NSLog(@"GET ERROR: %@ with data: %@. %@", URLString, parameters, error);
                                                   APIError* apiError = [[APIError alloc] initWithOperation:operation andError:error];
                                                   failure(apiError);
                                                   [weakSelf logError:apiError operation:operation];
                                               }
                                           }];
    
    return operation;
}




- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         apiError:(void (^)(APIError* error))failure
{
    MyOperationManager* __weak weakSelf = self;
    
    [self setDefaultJsonRequestSerializer];
    [self setAuthorizationToken];

//    NSLog(@"POST: %@ with data: %@", URLString, parameters);
    AFHTTPRequestOperation *operation = [super POST:URLString parameters:parameters
                                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                                                NSLog(@"POST SUCCESS: %@ with data: %@", URLString, parameters);
                                                success(operation, responseObject);
                                            }
                                            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                                                NSLog(@"POST ERROR: %@ with data: %@. %@", URLString, parameters, error);
                                                APIError* apiError = [[APIError alloc] initWithOperation:operation andError:error];
                                                failure(apiError);
                                                [weakSelf logError:apiError operation:operation];
    }];
    return operation;
}


- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
       constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         apiError:(void (^)(APIError* error))failure
{
    MyOperationManager* __weak weakSelf = self;
    
    [self setDefaultJsonRequestSerializer];
    [self setAuthorizationToken];

    return [super POST:URLString parameters:parameters constructingBodyWithBlock:block
               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                   success(operation, responseObject);
               }
               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   APIError* apiError = [[APIError alloc] initWithOperation:operation andError:error];
                   failure(apiError);
                   [weakSelf logError:apiError operation:operation];
               }];
}



- (AFHTTPRequestOperation *)DELETE:(NSString *)URLString
                        parameters:(id)parameters
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          apiError:(void (^)(APIError* error))failure{
    
     MyOperationManager* __weak weakSelf = self;
    
    [self setDefaultJsonRequestSerializer];
    [self setAuthorizationToken];

    AFHTTPRequestOperation *operation = [super DELETE:URLString parameters:parameters
                                           success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                               success(operation, responseObject);
                                           }
                                           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                               APIError* apiError = [[APIError alloc] initWithOperation:operation andError:error];
                                               failure(apiError);
                                               [weakSelf logError:apiError operation:operation];
                                           }];
    
    return operation;
}



-(void)checkError:(AFHTTPRequestOperation*) operation {
    if (operation.responseObject && [operation respondsToSelector:@selector(objectForKey:)]) {
        NSString* errorCode = [operation.responseObject objectForKey:@"ErrorCode"];
        if ([errorCode isEqualToString:@"NoGuest"]) {
        }
    }
}


- (AFHTTPRequestOperation*)downloadImage:(NSURL*)imageUrl
                                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:imageUrl];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:success failure:failure];
    [self.operationQueue addOperation:requestOperation];
    
    return requestOperation;
}


@end
