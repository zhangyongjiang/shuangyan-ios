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

+(AFHTTPRequestOperation*) MoneyAPI_Spend:(MoneyRequest*)req onSuccess:(void (^)(MoneyFlow *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) MoneyAPI_ListFriends:(NSNumber*)page onSuccess:(void (^)(MoneyFlowList *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) MoneyAPI_AddMoney:(MoneyRequest*)req onSuccess:(void (^)(MoneyFlow *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) UserAPI_Me:(void (^)(User *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) UserAPI_ListFriends:(NSString*)userId page:(NSNumber*)page onSuccess:(void (^)(UserDetailsList *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) UserAPI_GetUser:(NSString*)userId onSuccess:(void (^)(User *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) UserAPI_RegisterByEmail:(EmailRegisterRequest*)req onSuccess:(void (^)(User *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) UserAPI_RegisterByPhone:(PhoneRegisterRequest*)req onSuccess:(void (^)(User *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) UserAPI_SendPhoneValidationCode:(PhoneRegisterRequest*)req onSuccess:(void (^)(User *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) UserAPI_UploadUserImage:(NSDictionary*)filePart onSuccess:(void (^)(MediaContent *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) UserAPI_Friend:(FriendRequest*)req onSuccess:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) UserAPI_AcceptFriend:(NSString*)friendId onSuccess:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) UserAPI_Unfriend:(NSString*)friendId onSuccess:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) UserAPI_RejectFriend:(NSString*)friendId onSuccess:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) UserAPI_BlacklistFriend:(NSString*)friendId onSuccess:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) UserAPI_WechatRegisterUser:(WechatLoginRequest*)req onSuccess:(void (^)(User *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) UserAPI_PhoneLogin:(PhoneLoginRequest*)req onSuccess:(void (^)(User *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) UserAPI_ChangePassword:(ChangePasswordRequest*)req onSuccess:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) UserAPI_ResetPassword:(ResetPasswordRequest*)req onSuccess:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) UserAPI_RemoveUser:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) UserAPI_Interest:(NSString*)type targetType:(NSString*)targetType targetId:(NSString*)targetId onSuccess:(void (^)(UserInterest *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) UserAPI_GetInterest:(NSString*)type targetType:(NSString*)targetType targetId:(NSString*)targetId onSuccess:(void (^)(UserInterest *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) UserAPI_Uninterest:(NSString*)type targetType:(NSString*)targetType targetId:(NSString*)targetId onSuccess:(void (^)(UserInterest *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) UserAPI_ListUserBusinesss:(NSString*)keywords latitude:(NSNumber*)latitude longitude:(NSNumber*)longitude page:(NSNumber*)page onSuccess:(void (^)(UserList *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) UserAPI_Invite:(InviteRequest*)req onSuccess:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) UserAPI_RemoveAllUsers:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock;


@end
