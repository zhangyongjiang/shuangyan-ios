/*Auto generated file. Do not modify. Tue Nov 29 16:01:08 CST 2016 */

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "APIError.h"
#import "WebService.h"
#import "MoneyFlow.h"
#import "MoneyRequest.h"
#import "MoneyFlowList.h"
#import "User.h"
#import "UserDetailsList.h"
#import "EmailRegisterRequest.h"
#import "PhoneRegisterRequest.h"
#import "MediaContent.h"
#import "GenericResponse.h"
#import "FriendRequest.h"
#import "WechatLoginRequest.h"
#import "PhoneLoginRequest.h"
#import "ChangePasswordRequest.h"
#import "ResetPasswordRequest.h"
#import "UserInterest.h"
#import "UserList.h"
#import "InviteRequest.h"

@interface UserApi : NSObject

+(NSURLSessionDataTask*) MoneyAPI_Spend:(MoneyRequest*)req onSuccess:(void (^)(MoneyFlow *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) MoneyAPI_ListFriends:(NSNumber*)page onSuccess:(void (^)(MoneyFlowList *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) MoneyAPI_AddMoney:(MoneyRequest*)req onSuccess:(void (^)(MoneyFlow *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) UserAPI_Me:(void (^)(User *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) UserAPI_ListFriends:(NSString*)userId page:(NSNumber*)page onSuccess:(void (^)(UserDetailsList *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) UserAPI_GetUser:(NSString*)userId onSuccess:(void (^)(User *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) UserAPI_RegisterByEmail:(EmailRegisterRequest*)req onSuccess:(void (^)(User *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) UserAPI_RegisterByPhone:(PhoneRegisterRequest*)req onSuccess:(void (^)(User *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) UserAPI_SendPhoneValidationCode:(PhoneRegisterRequest*)req onSuccess:(void (^)(User *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) UserAPI_UploadUserImage:(NSDictionary*)filePart onSuccess:(void (^)(MediaContent *resp))successBlock onError:(void (^)(APIError *err))errorBlock progress:(void (^)(NSProgress *progress))progressBlock;

+(NSURLSessionDataTask*) UserAPI_Friend:(FriendRequest*)req onSuccess:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) UserAPI_AcceptFriend:(NSString*)friendId onSuccess:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) UserAPI_Unfriend:(NSString*)friendId onSuccess:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) UserAPI_RejectFriend:(NSString*)friendId onSuccess:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) UserAPI_BlacklistFriend:(NSString*)friendId onSuccess:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) UserAPI_WechatRegisterUser:(WechatLoginRequest*)req onSuccess:(void (^)(User *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) UserAPI_PhoneLogin:(PhoneLoginRequest*)req onSuccess:(void (^)(User *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) UserAPI_ChangePassword:(ChangePasswordRequest*)req onSuccess:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) UserAPI_ResetPassword:(ResetPasswordRequest*)req onSuccess:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) UserAPI_RemoveUser:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) UserAPI_Interest:(NSString*)type targetType:(NSString*)targetType targetId:(NSString*)targetId onSuccess:(void (^)(UserInterest *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) UserAPI_GetInterest:(NSString*)type targetType:(NSString*)targetType targetId:(NSString*)targetId onSuccess:(void (^)(UserInterest *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) UserAPI_Uninterest:(NSString*)type targetType:(NSString*)targetType targetId:(NSString*)targetId onSuccess:(void (^)(UserInterest *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) UserAPI_ListUserBusinesss:(NSString*)keywords latitude:(NSNumber*)latitude longitude:(NSNumber*)longitude page:(NSNumber*)page onSuccess:(void (^)(UserList *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) UserAPI_Invite:(InviteRequest*)req onSuccess:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) UserAPI_RemoveAllUsers:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock;


@end
