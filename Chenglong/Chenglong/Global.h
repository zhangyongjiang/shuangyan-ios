//
//  Global.h
//  Kaishi
//
//  Created by Hyun Cho on 6/23/15.
//  Copyright (c) 2015 BCGDV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "UserDetails.h"
#import "Constants.h"
#import "NSObject+TMCache.h"

static NSInteger max_second = 120;//验证码倒计时时间

@interface Global : NSObject

+ (User*)loggedInUser;
+ (void)setLoggedInUser:(User*)user;

+ (NSString*)versionString;
+ (NSString*)versionNoBundle;

@end


extern NSString* const kOauthTokenKey;
extern NSString* const kOauthTokenFirstTimeKey;

extern const NSInteger kMinNicknameLength;
extern const NSInteger kMaxNicknameLength;
