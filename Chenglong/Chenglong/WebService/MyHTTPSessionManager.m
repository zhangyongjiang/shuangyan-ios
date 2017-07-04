#import "MyHTTPSessionManager.h"
#import "WebService.h"
#import "MediaAttachment.h"

static double nocacheTillSecond = 0;
static double kDefaultRequestTimeOutInSecs = 30;
static double kRetryRequestTimeOutInSecs = 10;

NSUInteger kDefaultMaxRetries = 3;

@implementation MyHTTPSessionManager

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
    
    NSString* version = [Global versionString];
    NSString* UUID = [[NSUUID UUID] UUIDString];
    
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    self.requestSerializer.timeoutInterval = kDefaultRequestTimeOutInSecs;
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self.requestSerializer setValue:UUID forHTTPHeaderField:@"reqid"];
    [self.requestSerializer setValue:@"IOS" forHTTPHeaderField:@"deviceType"];
    [self.requestSerializer setValue:version forHTTPHeaderField:@"_version"];
    
}


- (void)setAuthorizationToken {
    NSString* token = [Lockbox stringForKey:kOauthTokenKey];
    
    if ( token.length > 0 ) {
        [self.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    } else {
        [self.requestSerializer setValue:@"" forHTTPHeaderField:@"Authorization"];
    }
}


- (void)logError:(APIError*)error operation:(NSURLSessionDataTask*)operation {
#ifdef LOG_API_ERRORS
    if ( error.rawError.code == NSURLErrorTimedOut ) {
        //        NSString* url = [operation.request.URL absoluteString];
        //        NSString* reqid = operation.request.allHTTPHeaderFields[@"reqid"];
        //        [Analytics trackEvent:@"ErrorTimedOut" params:@{@"url": url, @"reqid":reqid}];
        //        [Analytics flush];
    }
    
#endif
}

- (NSURLSessionDataTask*)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id))success apiError:(void (^)(APIError*))failure
{
    if ([self newWorkachablity] == NO)
    {
        [((AppDelegate *)([UIApplication sharedApplication].delegate)).window presentFailureTips:ZaoJiaoLocalizedString(@"NetworkNoConnect", nil)];
        failure(nil);
        return nil;
    }
    
    [self setDefaultJsonRequestSerializer];
    [self setAuthorizationToken];
    
    NSLog(@"GET: %@ with data: %@", URLString, parameters);
    [SVProgressHUD show];
    NSURLSessionDataTask *operation = [super GET:URLString parameters:parameters progress:nil
                                         success:^(NSURLSessionDataTask *operation, id responseObject) {
                                             [SVProgressHUD dismiss];
                                             //                                               NSLog(@"GET SUCCESS: %@ with data: %@", URLString, parameters);
                                             NSDictionary* dict = responseObject;
                                             NSNumber* obj = [dict objectForKey:@"success"];
                                             if(obj.intValue) {
                                                 success(operation, [dict objectForKey:@"data"]);
                                             }
                                             else {
                                                 APIError* apiError = [[APIError alloc] initWithOperation:operation andError:nil];
                                                 failure(apiError);
                                                 [self logError:apiError operation:operation];
                                             }
                                         }
                                         failure:^(NSURLSessionDataTask *operation, NSError *error) {
                                             [SVProgressHUD dismiss];
                                             //                                               NSLog(@"GET ERROR: %@ with data: %@. %@", URLString, parameters, error);
                                             APIError* apiError = [[APIError alloc] initWithOperation:operation andError:error];
                                             failure(apiError);
                                             [self logError:apiError operation:operation];
                                         }];
    
    return operation;
}


- (NSURLSessionDataTask*)GETWithRetries:(NSNumber*)retries urlString:(NSString *)URLString parameters:(id)parameters
                                success:(void (^)(NSURLSessionDataTask *, id))success
                               apiError:(void (^)(APIError*))failure
                                onRetry:(OnRequestRetries)onRetry
{
    
    //    if ([self newWorkachablity] == NO)
    //    {
    //        [((AppDelegate *)([UIApplication sharedApplication].delegate)).window presentFailureTips:ZaoJiaoLocalizedString(@"NetworkNoConnect", nil)];
    //        failure(nil);
    //        return nil;
    //    }
    
    MyHTTPSessionManager* __weak weakSelf = self;
    
    [self setDefaultJsonRequestSerializer];
    [self setAuthorizationToken];
    
    self.requestSerializer.timeoutInterval = kRetryRequestTimeOutInSecs;
    
    NSLog(@"GET: %@ with data: %@", URLString, parameters);
    NSURLSessionDataTask *operation = [super GET:URLString parameters:parameters progress:nil
                                         success:^(NSURLSessionDataTask *operation, id responseObject) {
                                             //                                               NSLog(@"GET SUCCESS: %@ with data: %@", URLString, parameters);
                                             NSDictionary* dict = responseObject;
                                             NSNumber* obj = [dict objectForKey:@"success"];
                                             if(obj.intValue) {
                                                 success(operation, [dict objectForKey:@"data"]);
                                             }
                                             else {
                                                 APIError* apiError = [[APIError alloc] initWithOperation:operation andError:nil];
                                                 failure(apiError);
                                                 [self logError:apiError operation:operation];
                                             }
                                         }
                                         failure:^(NSURLSessionDataTask *operation, NSError *error) {
                                             NSUInteger retriesRemaining = retries.integerValue - 1;
                                             if ( error != nil && error.code ==  NSURLErrorTimedOut && retriesRemaining > 0 ) {
                                                 NSLog(@"Retrying #%lu: %@", kDefaultMaxRetries - retriesRemaining, URLString);
                                                 NSURLSessionDataTask* newOperation = [weakSelf GETWithRetries:@(retriesRemaining) urlString:URLString parameters:parameters success:success apiError:failure onRetry:onRetry];
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




- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *operation, id responseObject))success
                      apiError:(void (^)(APIError* error))failure
{
    
    if ([self newWorkachablity] == NO)
    {
        [((AppDelegate *)([UIApplication sharedApplication].delegate)).window presentFailureTips:ZaoJiaoLocalizedString(@"NetworkNoConnect", nil)];
        return nil;
    }
    
    MyHTTPSessionManager* __weak weakSelf = self;
    
    [self setDefaultJsonRequestSerializer];
    [self setAuthorizationToken];
    
    NSLog(@"POST: %@ with data: %@", URLString, parameters);
    [SVProgressHUD show];
    NSURLSessionDataTask *operation = [super POST:URLString parameters:parameters progress:nil
                                          success:^(NSURLSessionDataTask *operation, id responseObject) {
                                              NSLog(@"POST SUCCESS: %@ with data: %@", URLString, parameters);
                                              NSDictionary* dict = responseObject;
                                              NSNumber* obj = [dict objectForKey:@"success"];
                                              if(obj.intValue) {
                                                  success(operation, [dict objectForKey:@"data"]);
                                              }
                                              else {
                                                  APIError* apiError = [[APIError alloc] initWithOperation:operation andError:nil];
                                                  failure(apiError);
                                                  [self logError:apiError operation:operation];
                                              }
                                              [SVProgressHUD dismiss];
                                          }
                                          failure:^(NSURLSessionDataTask *operation, NSError *error) {
                                              //                                                NSLog(@"POST ERROR: %@ with data: %@. %@", URLString, parameters, error);
                                              APIError* apiError = [[APIError alloc] initWithOperation:operation andError:error];
                                              failure(apiError);
                                              [weakSelf logError:apiError operation:operation];
                                              [SVProgressHUD dismiss];
                                          }];
    return operation;
}


- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                      progress:(void (^)(NSProgress *))uploadProgress
                       success:(void (^)(NSURLSessionDataTask *operation, id responseObject))success
                      apiError:(void (^)(APIError* error))failure
{
    
    if ([self newWorkachablity] == NO)
    {
        [((AppDelegate *)([UIApplication sharedApplication].delegate)).window presentFailureTips:ZaoJiaoLocalizedString(@"NetworkNoConnect", nil)];
        return nil;
    }
    
    MyHTTPSessionManager* __weak weakSelf = self;
    
    [self setDefaultJsonRequestSerializer];
    [self setAuthorizationToken];
    
    NSLog(@"POST: %@ with data: %@", URLString, parameters);
    [SVProgressHUD show];
    return [super POST:URLString parameters:parameters constructingBodyWithBlock:block progress:uploadProgress
               success:^(NSURLSessionDataTask *operation, id responseObject) {
                   [SVProgressHUD dismiss];
                   NSDictionary* dict = responseObject;
                   NSNumber* obj = [dict objectForKey:@"success"];
                   if(obj.intValue) {
                       success(operation, [dict objectForKey:@"data"]);
                   }
                   else {
                       APIError* apiError = [[APIError alloc] initWithOperation:operation andError:nil];
                       failure(apiError);
                       [self logError:apiError operation:operation];
                   }
               }
               failure:^(NSURLSessionDataTask *operation, NSError *error) {
                   [SVProgressHUD dismiss];
                   APIError* apiError = [[APIError alloc] initWithOperation:operation andError:error];
                   failure(apiError);
                   [weakSelf logError:apiError operation:operation];
               }];
}



- (NSURLSessionDataTask *)DELETE:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(NSURLSessionDataTask *operation, id responseObject))success
                        apiError:(void (^)(APIError* error))failure{
    
    if ([self newWorkachablity] == NO)
    {
        [((AppDelegate *)([UIApplication sharedApplication].delegate)).window presentFailureTips:ZaoJiaoLocalizedString(@"NetworkNoConnect", nil)];
        return nil;
    }
    
    MyHTTPSessionManager* __weak weakSelf = self;
    
    [self setDefaultJsonRequestSerializer];
    [self setAuthorizationToken];
    
    NSLog(@"DELETE: %@ with data: %@", URLString, parameters);
    NSURLSessionDataTask *operation = [super DELETE:URLString parameters:parameters
                                            success:^(NSURLSessionDataTask *operation, id responseObject) {
                                                NSDictionary* dict = responseObject;
                                                NSNumber* obj = [dict objectForKey:@"success"];
                                                if(obj.intValue) {
                                                    success(operation, [dict objectForKey:@"data"]);
                                                }
                                                else {
                                                    APIError* apiError = [[APIError alloc] initWithOperation:operation andError:nil];
                                                    failure(apiError);
                                                    [self logError:apiError operation:operation];
                                                }
                                            }
                                            failure:^(NSURLSessionDataTask *operation, NSError *error) {
                                                APIError* apiError = [[APIError alloc] initWithOperation:operation andError:error];
                                                failure(apiError);
                                                [weakSelf logError:apiError operation:operation];
                                            }];
    
    return operation;
}

+(NSURLSessionDataTask*)upload:(NSDictionary*)dataDic
                    parameters:(NSDictionary*)parameters
                        toPath:(NSString*)path
                       success:(void (^)(NSURLSessionDataTask *operation, id responseObject))success
                      progress:(void (^)(NSProgress* progress))progress
                       failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure

{
    MyHTTPSessionManager *manager = [[MyHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[WebService baseUrl]]];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString* version = [Global versionString];
    NSString* UUID = [[NSUUID UUID] UUIDString];
    [manager.requestSerializer setValue:version forHTTPHeaderField:@"ver"];
    [manager.requestSerializer setValue:UUID forHTTPHeaderField:@"reqid"];
    [manager.requestSerializer setValue:@"IOS" forHTTPHeaderField:@"deviceType"];
    [manager.requestSerializer setValue:version forHTTPHeaderField:@"_version"];
    
    [manager setAuthorizationToken];
    NSLog(@"POST: %@ with data: %@", path, parameters);
    NSURLSessionDataTask* operation = [manager POST:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSString* key in [dataDic keyEnumerator]) {
            id obj = [dataDic objectForKey:key];
            if ( IS_CLASS(obj, NSData) ) {
                NSData *data = [dataDic objectForKey:key];
                NSString* filename = [dataDic objectForKey:@"filename"];
                [formData appendPartWithFileData:data name:key fileName:filename mimeType:@"image/jpeg"];
            } else if ( IS_CLASS(obj, NSArray) ) {
                NSArray* dataArray  = obj;
                for (id data in dataArray ) {
                   if (IS_CLASS(data, NSData)) {
                        [formData appendPartWithFileData:data name:key fileName:@"file.jpeg" mimeType:@"image/jpeg"];
                   }else if ( IS_CLASS(data, MediaAttachment)) {
                       MediaAttachment *attachment = (MediaAttachment*)data;
                       if (attachment.media) {
                           [formData appendPartWithFileData:attachment.media name:key fileName:@"file.jpeg" mimeType:@"image/jpeg"];
                       }
                   }
                }
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if ( progress != nil && uploadProgress != nil ) {
            progress(uploadProgress);
        }
        
    } success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSNumber* obj = [dict objectForKey:@"success"];
        if(obj.intValue) {
            success(operation, [dict objectForKey:@"data"]);
        }
        else {
            failure(operation, nil);
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        failure(operation, error);
        APIError* apiError = [[APIError alloc] initWithOperation:operation andError:error];
        [manager logError:apiError operation:operation];
    }];
    
    return operation;
}

- (BOOL)newWorkachablity
{
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    if (manger.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable)
    {
        return NO;
    }
    return YES;
}

@end
