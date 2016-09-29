#import <Foundation/Foundation.h>
#import "AFNetworking.h"

#ifndef IS_CLASS
#define IS_CLASS(__obj, __class)                          [__obj isKindOfClass:[__class class]]
#endif

@interface APIError : NSObject

@property(strong,nonatomic)NSString* errorCode;
@property(strong,nonatomic)NSString* stack;
@property(strong,nonatomic)NSString* errorMsg;
@property(assign,nonatomic)NSInteger statusCode;
@property(assign,nonatomic)BOOL processed;
@property(strong,nonatomic)NSError* rawError;

-(id)initWithOperation:(AFHTTPRequestOperation*)operation andError:(NSError *)error;

-(BOOL)isUnknown;
-(BOOL)isInvalidInput;
-(BOOL)isInvalidPassword;
-(BOOL)isDuplicated;
-(BOOL)isNoGuest;
-(BOOL)isPermissionDenied;
-(BOOL)isNotFound;
-(BOOL)isStoreExists;
-(BOOL)isNoInventory;
-(BOOL)isInvalidStatus;
-(BOOL)isBillingError;
-(BOOL)isInvalidJson;
-(BOOL)isInvalidId;
-(BOOL)isUserHasNoStore;
-(BOOL)isNoStoreOwner;
-(BOOL)isSmsError;
-(BOOL)isReauthenticationError;
-(BOOL)isRequestCancelled;
-(BOOL)isInvalidDay;

@end
