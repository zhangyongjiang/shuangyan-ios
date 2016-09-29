/*Auto generated file. Do not modify. Thu Sep 29 23:53:33 CST 2016 */

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "APIError.h"
#import "WebService.h"
#import "GenericResponse.h"
#import "MediaContent.h"
#import "User.h"
#import "PhoneRegisterRequest.h"
#import "EmailRegisterRequest.h"
#import "UserDetailsList.h"
#import "FriendRequest.h"

@interface UserApi : NSObject

+(AFHTTPRequestOperation*) UserAPI_BlacklistFriend:(NSString*)friendId onSuccess:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) UserAPI_AcceptFriend:(NSString*)friendId onSuccess:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) UserAPI_RejectFriend:(NSString*)friendId onSuccess:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) UserAPI_UploadUserImage:(NSDictionary*)filePart onSuccess:(void (^)(MediaContent *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) UserAPI_SendPhoneValidationCode:(PhoneRegisterRequest*)req onSuccess:(void (^)(User *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) UserAPI_RegisterByPhone:(PhoneRegisterRequest*)req onSuccess:(void (^)(User *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) UserAPI_RegisterByEmail:(EmailRegisterRequest*)req onSuccess:(void (^)(User *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) UserAPI_ListFriends:(NSString*)userId page:(NSNumber*)page onSuccess:(void (^)(UserDetailsList *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) UserAPI_Friend:(FriendRequest*)req onSuccess:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) UserAPI_Unfriend:(NSString*)friendId onSuccess:(void (^)(GenericResponse *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) UserAPI_Me:(void (^)(User *resp))successBlock onError:(void (^)(APIError *err))errorBlock;


@end
