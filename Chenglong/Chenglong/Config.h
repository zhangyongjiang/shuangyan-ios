//
//  Config.h
//  Kaishi
//
//  Created by Hyun Cho on 6/12/15.
//  Copyright (c) 2015 BCGDV. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef CONFIG_APP_STORE
#define LOG_API_ERRORS 1
#endif


#ifdef CONFIG_APP_STORE

#define KaishiLocalizedString(key, comment) \
    NSLocalizedString(key, comment)

#else

#define KaishiLocalizedString(key, comment) \
    [[Config.shared currentLocalizationBundle] localizedStringForKey:(key) value:@"" table:nil]

#endif

typedef NS_ENUM(NSInteger, DeploymentType) {
    DeploymentTypeDev,
    DeploymentTypeStaging,
    DeploymentTypeAppStore,
};

@interface Config : NSObject

+ (instancetype)shared;
+ (DeploymentType)deploymentType;

- (NSArray*)supportedCountries;
- (NSString*)countryCode:(NSString*)countryName;

#ifndef CONFIG_APP_STORE
- (void)toggleLocalizations;
@property (nonatomic, strong) NSBundle* currentLocalizationBundle;
#endif

// kicktracker
@property (nonatomic, assign) double kickTrackerSessionTimeout;
@property (nonatomic, readonly) double kickTrackerSessionTimeoutMillisecs;

@property (nonatomic, assign) double journalReminderTimeout;
@property (nonatomic, assign) double nutritionReminderTimeout;

@property (nonatomic, strong) NSDate* communityReminderTimeout;

@property (nonatomic, assign) CGFloat defaultImageMaxHeight;
@property (nonatomic, assign) CGFloat defaultImageQuality;

@end
