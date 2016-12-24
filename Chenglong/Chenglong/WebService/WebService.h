#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "MyHTTPSessionManager.h"

@interface WebService : NSObject

+ (NSArray*)endPoints;
+ (NSString *)baseUrl;
+ (NSString *)sharingBaseUrl;
+ (NSString *)tosUrl;
+ (MyHTTPSessionManager*)getOperationManager;
+ (void)saveCookies;
+ (void)loadCookies;
+ (void)removeAllCookies;
+ (BOOL)hasSessionCookies;
+ (void)showError:(NSError*)err withOperation:(NSURLSessionDataTask*)operation;
+ (NSString*)currentEndPoint;
+ (NSInteger)currentEndPointIndex;
+ (void)setCurrentEndPoint:(NSString*)endPoint;

@end
