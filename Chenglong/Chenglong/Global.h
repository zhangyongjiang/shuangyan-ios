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
#import "UIView+Position.h"
#import "UIColor+String.h"
#import "FitLabel.h"

#import "UserApi.h"
#import "CourseApi.h"
#import "File.h"
#import "Dbase.h"

static NSInteger max_second = 120;//验证码倒计时时间


//日记类型
typedef NS_ENUM(NSInteger, FileMediaType) {
    FileMediaTypeNone = 0,//无
    FileMediaTypeAdd = 1,//添加
    FileMediaTypePhoto = 2,//图片
    FileMediaTypeVideo = 3,//视频
    FileMediaTypeAudio = 4//音频
};

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

extern NSString* const kCachedUserNicknameKey;
extern NSString* const kCachedUserImgPath;

//登录成功
extern NSString* const kAppLoginSuccessNotificationKey;
//获取me成功
extern NSString* const kGetMeInfoSuccessNotificationKey;
//发布文件成功
extern NSString* const kPublishFileSuccessNotificationKey;

#define NotificationRefreshControl      @"NotificationRefreshControl"
#define NotificationEndOfDisplay        @"NotificationEndOfDisplay"
#define NotificationPushController      @"NotificationPushController"
#define NotificationPresentController   @"NotificationPresentController"
#define NotificationNewReview           @"NotificationNewReview"
#define NotificationLogout              @"NotificationLogout"
#define NotificationNoGuest             @"NotificationNoGuest"
#define NotificationAlert               @"NotificationAlert"
#define NotificationMeChanged           @"NotificationMeChanged"
#define NotificationCartChanged         @"NotificationCartChanged"
#define NotificationMsgChanged          @"NotificationMsgChanged"
#define NotificationLangChanged         @"NotificationLangChanged"
#define NotificationTextFieldFocused    @"NotificationTextFieldFocused"
#define NotificationProductChanged      @"NotificationProductChanged"
#define NotificationBackgroundImage     @"NotificationBackgroundImage"
#define NotificationEditing             @"NotificationEditing"
#define NotificationLabelTabChanged     @"NotificationLabelTabChanged"
#define NotificationCouponChanged       @"NotificationCouponChanged"
#define NotificationRadioValueChanged   @"NotificationRadioValueChanged"
#define NotificationGalleryPageChanged  @"NotificationGalleryPageChanged"

#define Margin  15

