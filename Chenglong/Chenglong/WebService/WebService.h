#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "MyOperationManager.h"

@interface WebService : NSObject

+ (NSArray*)endPoints;
+ (NSString *)baseUrl;
+ (NSString *)sharingBaseUrl;
+ (NSString *)tosUrl;
+ (MyOperationManager*)getOperationManager;
+ (void)saveCookies;
+ (void)loadCookies;
+ (void)removeAllCookies;
+ (BOOL)hasSessionCookies;
+ (void)showError:(NSError*)err withOperation:(AFHTTPRequestOperation*)operation;
+ (NSString*)currentEndPoint;
+ (NSInteger)currentEndPointIndex;
+ (void)setCurrentEndPoint:(NSString*)endPoint;

+(AFHTTPRequestOperation*)upload:(NSDictionary*)dataDic
                      parameters:(NSDictionary*)parameters
                          toPath:(NSString*)path
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        apiError:(void (^)(APIError *err))errorBlock;

@end