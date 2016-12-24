//
//  Config.m
//  ZaoJiao
//
//  Created by wangyaochang on 2016/12/24.
//  Copyright © 2016年 Chenglong. All rights reserved.
//

#import "Config.h"

static Config *_shared = nil;

#ifndef CONFIG_APP_STORE
static NSString* const kCurrentLocalization = @"currentLocalization";
#endif

@interface Config ()
{
    
}

@end

@implementation Config

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _shared = [[Config alloc] init];
#ifndef CONFIG_APP_STORE
        NSString* current = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentLocalization];
        if ( current == nil ) {
            [[NSUserDefaults standardUserDefaults] setObject:@"main" forKey:kCurrentLocalization];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        [_shared setLocalizationBundle];
#endif

    });
    
    return _shared;
}


// DeploymentTypeDev: could be Debug or Release build.  It has the latest changes from the development team including work in progress
// DeploymentTypeStaging: could be Debug or Release build.  It has the latest features that are stable.  Contains no work in progress
// DeploymentTypeAppStore: Release build.  Submission quality build

+ (DeploymentType)deploymentType {
    NSString* bundleId = [[NSBundle mainBundle] bundleIdentifier];
    if ( [bundleId isEqualToString:@"com.bcgdv.haoyunstaging"] ) {
        return DeploymentTypeStaging;
    } else if ( [bundleId isEqualToString:@"com.bcgdv.haoyun"] ) {
        return DeploymentTypeAppStore;
    } else {
        return DeploymentTypeDev;
    }
}


- (id)init {
    self = [super init];
    
    _defaultImageQuality = 0.8;
    _defaultImageMaxHeight = 540; // 1080 at 2x
    
    return self;
}


- (NSArray*)supportedCountries {

    return @[@{@"country": ZaoJiaoLocalizedString(@"China", nil), @"code":@"86"},
             @{@"country": ZaoJiaoLocalizedString(@"UnitedStates", nil), @"code":@"1"}];
}


- (NSString*)countryCode:(NSString*)countryName {
    NSArray* supportedCountries = [[Config shared] supportedCountries];
    for ( NSDictionary* dict in supportedCountries ) {
        if ( [countryName isEqualToString:dict[@"country"]] ) {
            return dict[@"code"];
        }
    }
    
    return nil;
}


#pragma mark Dev Bundle
#ifndef CONFIG_APP_STORE
- (void)setLocalizationBundle {
    NSString* current = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentLocalization];
    if ( [current isEqualToString:@"main"] ) {
        self.currentLocalizationBundle = [NSBundle mainBundle];
    } else {
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"DevBundle" ofType:@"bundle"];
        self.currentLocalizationBundle = [NSBundle bundleWithPath:bundlePath];
    }
}


- (void)toggleLocalizations {
    NSString* current = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentLocalization];
    if ( [current isEqualToString:@"main"] ) {
        [[NSUserDefaults standardUserDefaults] setObject:@"DevBundle" forKey:kCurrentLocalization];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:@"main" forKey:kCurrentLocalization];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    [_shared setLocalizationBundle];
}

#endif

@end
