//
//  Config.m
//  Kaishi
//
//  Created by Hyun Cho on 6/12/15.
//  Copyright (c) 2015 BCGDV. All rights reserved.
//

#import "Config.h"

static Config *_shared = nil;

#ifndef CONFIG_APP_STORE
static NSString* const kCurrentLocalization = @"currentLocalization";
#endif

// Kick tracker
static NSString* const kKickTrackerSessionTimeOut = @"kickTrackerSessionTimeOut";
static NSString* const kJournalReminderTimeOut = @"journalReminderTimeOut";
static NSString* const kNutritionReminderTimeOut = @"nutritionReminderTimeOut";
static NSString* const kCommunityReminderTimeOut = @"communityReminderTimeOut";

@interface Config ()
{
    double _kickTrackerSessionTimeout;
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
    } else if ( [bundleId isEqualToString:@"com.kaishi.xinkaishi"] ) {
        return DeploymentTypeAppStore;
    } else {
        return DeploymentTypeDev;
    }
}


- (id)init {
    self = [super init];
    
    // kicktracker timeout
    NSNumber* timeout = [[NSUserDefaults standardUserDefaults] objectForKey:kKickTrackerSessionTimeOut];
    if ( timeout != nil ) {
        _kickTrackerSessionTimeout = timeout.doubleValue;
    } else {
        _kickTrackerSessionTimeout = (60 * 60); // 1 hour
        
        [[NSUserDefaults standardUserDefaults] setObject:@(_kickTrackerSessionTimeout) forKey:kKickTrackerSessionTimeOut];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    // community timeout
    timeout = [[NSUserDefaults standardUserDefaults] objectForKey:kCommunityReminderTimeOut];
    if ( timeout != nil ) {
        if ( [[NSDate dateWithTimeIntervalSince1970:timeout.doubleValue] compare:[NSDate date]] != NSOrderedAscending ) {
            _communityReminderTimeout = [NSDate dateWithTimeIntervalSince1970:timeout.doubleValue];
        } else {
            // the date is from the past, so remove the override
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCommunityReminderTimeOut];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    _defaultImageQuality = 0.8;
    _defaultImageMaxHeight = 540; // 1080 at 2x
    
    return self;
}


- (NSArray*)supportedCountries {

    return @[@{@"country": KaishiLocalizedString(@"China", nil), @"code":@"86"},
             @{@"country": KaishiLocalizedString(@"UnitedStates", nil), @"code":@"1"}];
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

#pragma mark KickTracker related
- (void)setKickTrackerSessionTimeout:(double)kickTrackerSessionTimeout {
    _kickTrackerSessionTimeout = kickTrackerSessionTimeout;
    
    [[NSUserDefaults standardUserDefaults] setObject:@(kickTrackerSessionTimeout) forKey:kKickTrackerSessionTimeOut];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (double)kickTrackerSessionTimeout {
    return _kickTrackerSessionTimeout;
}


- (double)kickTrackerSessionTimeoutMillisecs {
    return self.kickTrackerSessionTimeout * 1000.0;
}


- (void)setJournalReminderTimeout:(double)journalReminderTimeout {
    _journalReminderTimeout = journalReminderTimeout;
    
    [[NSUserDefaults standardUserDefaults] setObject:@(journalReminderTimeout) forKey:kJournalReminderTimeOut];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)setNutritionReminderTimeout:(double)nutritionReminderTimeout {
    _nutritionReminderTimeout = nutritionReminderTimeout;
    
    [[NSUserDefaults standardUserDefaults] setObject:@(nutritionReminderTimeout) forKey:kNutritionReminderTimeOut];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)setCommunityReminderTimeout:(NSDate*)communityReminderTimeout {
    _communityReminderTimeout = communityReminderTimeout;
    
    [[NSUserDefaults standardUserDefaults] setObject:@([communityReminderTimeout timeIntervalSince1970]) forKey:kCommunityReminderTimeOut];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
