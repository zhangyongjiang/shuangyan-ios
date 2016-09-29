#import "APIError.h"
#import "Config.h"

@implementation APIError

-(id)initWithOperation:(AFHTTPRequestOperation *)operation andError:(NSError *)error {
    self = [super init];

    self.rawError = error;
    self.statusCode = [operation.response statusCode];
    if (self.statusCode == 500 && IS_CLASS(operation.responseObject, NSDictionary) ) {
        self.errorCode = [operation.responseObject objectForKey:@"errorCode"];
        if ( self.errorCode == nil ) {
            self.errorCode = @"System Error";
        }
        NSDictionary* response = operation.responseObject;
        if ( IS_CLASS(response, NSDictionary) && response[@"message"] != nil ) {
            self.errorMsg = response[@"message"];
        } else if ( IS_CLASS(response, NSDictionary) && response[@"errorMsg"] != nil ) {
            self.errorMsg = response[@"errorMsg"];
        } else {
            self.errorMsg = @"Please report. Thanks.";
        }
    } else if (operation.responseObject &&
             IS_CLASS(operation.responseObject, NSDictionary) &&
             [operation.responseObject respondsToSelector:@selector(objectForKey:)]) {
        self.errorCode = [operation.responseObject objectForKey:@"errorCode"];
        self.errorMsg = [operation.responseObject objectForKey:@"errorMsg"];
        if ( self.errorCode.length == 0 ) {
            self.errorCode = [operation.responseObject objectForKey:@"error"];
        }
        if ( self.errorMsg.length == 0 ) {
            self.errorMsg = [operation.responseObject objectForKey:@"error_description"];
        }
    } else if([@"NSURLErrorDomain" isEqualToString:error.domain]) {
        
        self.errorCode = [error localizedDescription];
        self.errorMsg = [error localizedRecoverySuggestion];
        
        if ( self.errorMsg == nil ) {
            if(error.code == NSURLErrorNotConnectedToInternet) { // -1009
                self.errorMsg = KaishiLocalizedString(@"NetworkError", nil);
            } else if(error.code == NSURLErrorTimedOut) { // -1001
#ifdef CONFIG_APP_STORE
                // don't show the time outs for app store version
                self.errorMsg = nil;
                self.errorCode = nil;
#else
//                NSString* urlString = [operation.request.URL absoluteString];
//                self.errorMsg = urlString;
                self.errorMsg = KaishiLocalizedString(@"TryAgainError", nil);
#endif
            } else if ( error.code == NSURLErrorNetworkConnectionLost ) { // -1005
                self.errorMsg = KaishiLocalizedString(@"NetworkLostError", nil);
            } else if ( error.code == NSURLErrorCannotConnectToHost ) { // -1004
                self.errorMsg = KaishiLocalizedString(@"TryAgainError", nil);
            } else if ( error.code == NSURLErrorCancelled ) { // -999
                // an exception.. if we cancel a request, don't show any message.
                self.errorMsg = nil;
                self.errorCode = nil;
            } else {
                self.errorMsg = KaishiLocalizedString(@"TryAgainError", nil);
            }
        }
        
    } else {
        self.errorCode = KaishiLocalizedString(@"UnknownError", nil);
        self.errorMsg = [NSString stringWithFormat:@"%@", operation.response];
    }
    
    if ( IS_CLASS(self.errorCode, NSNull) ) {
        self.errorCode = nil;
    } else if ( IS_CLASS(self.errorMsg, NSNull) ) {
        self.errorMsg = nil;
    }
    
    return self;
}

-(NSString*)description {
    if (self.errorMsg) {
        return [NSString stringWithFormat:@"%@\n%@", self.errorCode, self.errorMsg];
    }
    else
        return [NSString stringWithFormat:@"%@", self.errorCode];

}

-(BOOL)isUnknown{
    return [self.errorCode isEqualToString:@"Unknown"];
}

-(BOOL)isInvalidInput{
    return [self.errorCode isEqualToString:@"InvalidInput"];
}

-(BOOL)isInvalidPassword{
    return [self.errorCode isEqualToString:@"InvalidPassword"];
}

-(BOOL)isDuplicated{
    return [self.errorCode isEqualToString:@"Duplicated"];
}

-(BOOL)isNoGuest{
    return [self.errorCode isEqualToString:@"NoGuest"];
}

-(BOOL)isPermissionDenied{
    return [self.errorCode isEqualToString:@"PermissionDenied"];
}

-(BOOL)isNotFound{
    return [self.errorCode isEqualToString:@"NotFound"];
}

-(BOOL)isStoreExists{
    return [self.errorCode isEqualToString:@"StoreExists"];
}

-(BOOL)isNoInventory{
    return [self.errorCode isEqualToString:@"NoInventory"];
}

-(BOOL)isInvalidStatus{
    return [self.errorCode isEqualToString:@"InvalidStatus"];
}

-(BOOL)isBillingError{
    return [self.errorCode isEqualToString:@"BillingError"];
}

-(BOOL)isInvalidJson{
    return [self.errorCode isEqualToString:@"InvalidJson"];
}

-(BOOL)isInvalidId{
    return [self.errorCode isEqualToString:@"InvalidId"];
}

-(BOOL)isUserHasNoStore{
    return [self.errorCode isEqualToString:@"UserHasNoStore"];
}

-(BOOL)isNoStoreOwner{
    return [self.errorCode isEqualToString:@"NoStoreOwner"];
}

-(BOOL)isSmsError{
    return [self.errorCode isEqualToString:@"SmsError"];
}

-(BOOL)isReauthenticationError{
    return [self.errorCode isEqualToString:@"ReauthenticationError"];
}


-(BOOL)isRequestCancelled {
    return (self.rawError.code == NSURLErrorCancelled) && ([self.rawError.domain isEqualToString:NSURLErrorDomain]);
}


-(BOOL)isInvalidDay {
    return [self.errorMsg isEqualToString:@"Invalid day"];
}

@end
