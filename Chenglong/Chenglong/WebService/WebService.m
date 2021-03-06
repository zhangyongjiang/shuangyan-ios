#import "WebService.h"
#import "ObjectMapper.h"
#import "Global.h"

static WebService* instance;
static BOOL useLocalHost = NO;
static NSString* const kSessionCookies = @"sessionCookies";
static NSString* const kCurrentDefaultEndPointKey = @"kCurrentDefaultEndPointKey";

@interface WebService()

@property(strong, nonatomic)MyHTTPSessionManager* operationManager;

@end

@implementation WebService

+(void)load {
    [self loadCookies];
    instance = [[WebService alloc] init];
}


+ (NSArray*)endPoints {
    return @[@"http://api.babazaojiao.com"];
}


+(MyHTTPSessionManager*)getOperationManager {
    return instance.operationManager;
}

+ (NSString *)baseUrl
{
    if (useLocalHost) {
        return @"http://localhost:9090/api";
    }
    else {
        return [WebService currentEndPoint];
    }
}


+ (NSString *)sharingBaseUrl {
    if ( [[WebService currentEndPoint] rangeOfString:@"stage"].length > 0 ) {
        return @"http://www-stage.mykaishi.com";
    } else if ( [[WebService currentEndPoint] rangeOfString:@"dev"].length > 0 ) {
        return @"http://ms0.pr720.com:3000";
    } else {
        return @"http://www.mykaishi.com";
    }
}


+ (NSString*)tosUrl {
    return @"http://www.mykaishi.com/policies/terms";
}


+ (void)saveCookies{
    NSData *savecookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: savecookiesData forKey:kSessionCookies];
    [defaults synchronize];
}

+ (void)loadCookies{
    NSArray *loadcookiesarray = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:kSessionCookies]];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie * c in loadcookiesarray){
//        NSLog(@"=== cookie %@", c);
        [cookieStorage setCookie: c];
    }
}

+ (void)removeAllCookies{
    NSArray *loadcookiesarray = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:kSessionCookies]];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie * c in loadcookiesarray){
        [cookieStorage deleteCookie: c];
    }
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSessionCookies];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (BOOL)hasSessionCookies {
    return ([[NSUserDefaults standardUserDefaults] objectForKey:kSessionCookies] != nil);
}


-(id)init {
    self = [super init];

    [self createOperationManager];

    return self;
}


- (void)createOperationManager {
    
    MyHTTPSessionManager *manager = [[MyHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[WebService baseUrl]]];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    [manager setDefaultJsonRequestSerializer];
    [manager setAuthorizationToken];
    
    self.operationManager = manager;
}


+ (void)showError:(NSError *)err withOperation:(NSURLSessionDataTask *)operation {
}


+ (NSString*)currentEndPoint {
    NSString* endPoint = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentDefaultEndPointKey];
    if ( endPoint == nil ) {
        return [[WebService endPoints] lastObject];
    } else {
        return endPoint;
    }
}


+ (void)setCurrentEndPoint:(NSString*)endPoint {
    [[NSUserDefaults standardUserDefaults] setObject:endPoint forKey:kCurrentDefaultEndPointKey];
    
    [instance createOperationManager];
}


+ (NSInteger)currentEndPointIndex {
    NSArray* endPoints = [WebService endPoints];
    NSInteger index = [endPoints indexOfObject:[WebService currentEndPoint]];
    return index;
}

@end
