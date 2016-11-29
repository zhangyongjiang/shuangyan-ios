#import "WebService.h"
#import "ObjectMapper.h"
#import "Global.h"

static WebService* instance;
static BOOL useLocalHost = NO;
static NSString* const kSessionCookies = @"sessionCookies";
static NSString* const kCurrentDefaultEndPointKey = @"kCurrentDefaultEndPointKey";

@interface WebService()

@property(strong, nonatomic)MyOperationManager* operationManager;

@end

@implementation WebService

+(void)load {
    [self loadCookies];
    instance = [[WebService alloc] init];
}


+ (NSArray*)endPoints {
    return @[@"http://api.babazaojiao.com"];
}


+(MyOperationManager*)getOperationManager {
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
    
    MyOperationManager *manager = [[MyOperationManager alloc] initWithBaseURL:[NSURL URLWithString:[WebService baseUrl]]];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    [manager setDefaultJsonRequestSerializer];
    [manager setAuthorizationToken];
    
    self.operationManager = manager;
}


+ (void)showError:(NSError *)err withOperation:(AFHTTPRequestOperation *)operation {
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

+(AFHTTPRequestOperation*)upload:(NSDictionary*)dataDic
                      parameters:(NSDictionary*)parameters
                          toPath:(NSString*)path
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         apiError:(void (^)(APIError *err))errorBlock

{
    MyOperationManager *manager = [[MyOperationManager alloc] initWithBaseURL:[NSURL URLWithString:[WebService baseUrl]]];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager setAuthorizationToken];
    //    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    AFHTTPRequestOperation* operation = [manager POST:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSString* key in [dataDic keyEnumerator]) {
            id obj = [dataDic objectForKey:key];
            if ( IS_CLASS(obj, NSData) ) {
                NSData *data = [dataDic objectForKey:key];
                [formData appendPartWithFileData:data name:key fileName:@"file.jpeg" mimeType:@"image/jpeg"];
            } else if ( IS_CLASS(obj, NSArray) ) {
                NSArray* dataArray  = obj;
                for (id data in dataArray ) {
                        [formData appendPartWithFileData:data name:key fileName:@"file.jpeg" mimeType:@"image/jpeg"];
                }
            }
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        APIError* apiError = [[APIError alloc] initWithOperation:operation andError:error];
        errorBlock(apiError);
    }];
    
    return operation;
}

@end
