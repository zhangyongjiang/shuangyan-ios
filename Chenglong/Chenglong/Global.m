//
//  Global.m
//  Kaishi
//
//  Created by Hyun Cho on 6/23/15.
//  Copyright (c) 2015 BCGDV. All rights reserved.
//

#import "Global.h"
#import "Lockbox.h"
#import "WebService.h"
#import "ObjectMapper.h"

NSString* const kOauthTokenKey = @"XinkaishiOauthTokenKey";
NSString* const kOauthTokenFirstTimeKey = @"OauthTokenFirstTimeKey";

NSString* const kSessionCookies = @"sessionCookies";

const NSInteger kMinNicknameLength = 1;
const NSInteger kMaxNicknameLength = 12;

NSString* const kCacheUserModel = @"kCacheUserModel";
NSString* const kCacheUserPhone = @"CacheUserPhone";
NSString* const kCachedUserIdKey = @"CachedUserIdKey";
NSString* const kCachedUserNicknameKey = @"CachedUserNicknameKey";
NSString* const kCachedUserImgPath = @"CachedUserImgPath";

//登录成功
NSString* const kAppLoginSuccessNotificationKey = @"kAppLoginSuccessNotificationKey";
//获取me成功
NSString* const kGetMeInfoSuccessNotificationKey = @"kGetMeInfoSuccessNotificationKey";
//发布文件成功
NSString* const kPublishFileSuccessNotificationKey = @"kPublishFileSuccessNotificationKey";

static Global *_shared = nil;

@interface Global ()

@property (nonatomic, strong) User* loggedInUser;
@property (nonatomic, strong) UserDetails *loggedInUserDetails;

@end


@implementation Global

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _shared = [[Global alloc] init];
    });
    
    return _shared;
}


+ (User*)loggedInUser {
    User *user = [User tm_objectForKey:kCacheUserModel];
    
    if ([Global shared].loggedInUser == nil && user != nil) {
        [Global shared].loggedInUser = user;
    }
    return [Global shared].loggedInUser;
}

+ (void)setLoggedInUser:(User*)user {
    
    [Global shared].loggedInUser = user;
    
    if ( user != nil ) {
        [User tm_setObject:user forKey:kCacheUserModel];
        
        [[NSUserDefaults standardUserDefaults] setObject:user.id forKey:kCachedUserIdKey];
        [[NSUserDefaults standardUserDefaults] setObject:user.name forKey:kCachedUserNicknameKey];
        [[NSUserDefaults standardUserDefaults] setObject:user.imgPath forKey:kCachedUserImgPath];
        [[NSUserDefaults standardUserDefaults] setObject:user.phone forKey:kCacheUserPhone];
        
        [WebService saveCookies];
        
    } else {
        [User tm_removeObjectForKey:kCacheUserModel];
        [WebService removeAllCookies];
    }
    [Lockbox setString:nil forKey:kOauthTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+ (NSString*)versionString {
    NSString* shortClientVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString* clientVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString* version = [NSString stringWithFormat:@"%@.%@", shortClientVersion, clientVersion];
    return version;
}

+ (NSString*)versionNoBundle
{
    NSString* shortClientVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return shortClientVersion;
}


@end
