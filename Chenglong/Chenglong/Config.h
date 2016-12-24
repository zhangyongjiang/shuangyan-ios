//
//  Config.h
//  ZaoJiao
//
//  Created by wangyaochang on 2016/12/24.
//  Copyright © 2016年 Chenglong. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef CONFIG_APP_STORE
#define LOG_API_ERRORS 1
#endif


#ifdef CONFIG_APP_STORE

#define ZaoJiaoLocalizedString(key, comment) \
    NSLocalizedString(key, comment)

#else

#define ZaoJiaoLocalizedString(key, comment) \
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

@property (nonatomic, assign) CGFloat defaultImageMaxHeight;
@property (nonatomic, assign) CGFloat defaultImageQuality;

@end
