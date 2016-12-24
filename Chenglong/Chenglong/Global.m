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


static NSString* const kCacheUserPhone = @"CacheUserPhone";
static NSString* const kCachedUserIdKey = @"CachedUserIdKey";
static NSString* const kCachedUserNicknameKey = @"CachedUserNicknameKey";
static NSString* const kCachedUserImgPath = @"CachedUserImgPath";


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
    return [Global shared].loggedInUser;
}


+ (User*)cachedUser {
    User* user = [[User alloc] init];

    NSString* userId = [[NSUserDefaults standardUserDefaults] objectForKey:kCachedUserIdKey];

    if ( userId.length > 0 ) {
        NSString* nickName = [[NSUserDefaults standardUserDefaults] objectForKey:kCachedUserNicknameKey];
        NSString* imgPath = [[NSUserDefaults standardUserDefaults] objectForKey:kCachedUserImgPath];
        NSString* phone = [[NSUserDefaults standardUserDefaults] objectForKey:kCacheUserPhone];
        user.id = userId;
        user.name = nickName;
        user.phone = phone;
        user.imgPath = imgPath;
        
        return user;
    } else {
        return nil;
    }
}


+ (void)setLoggedInUser:(User*)user {
    [Global shared].loggedInUser = user;
    
    
    if ( user != nil ) {
        [[NSUserDefaults standardUserDefaults] setObject:user.id forKey:kCachedUserIdKey];
        [[NSUserDefaults standardUserDefaults] setObject:user.name forKey:kCachedUserNicknameKey];
        [[NSUserDefaults standardUserDefaults] setObject:user.imgPath forKey:kCachedUserImgPath];
        [[NSUserDefaults standardUserDefaults] setObject:user.phone forKey:kCacheUserPhone];
        
        [WebService saveCookies];
        
    } else {
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCachedUserIdKey];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCachedUserNicknameKey];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCachedUserImgPath];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCacheUserPhone];

        [Lockbox setString:@"" forKey:kOauthTokenKey]; // wipe out the auth token
        
        [WebService removeAllCookies];
        
    }
    
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
