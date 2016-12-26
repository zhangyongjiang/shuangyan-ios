//
//  SDiPhoneVersion.m
//  SDiPhoneVersion
//
//  Created by Sebastian Dobrincu on 09/09/14.
//  Copyright (c) 2014 Sebastian Dobrincu. All rights reserved.
//

#import "SDiPhoneVersion.h"

@implementation SDiPhoneVersion

+(NSDictionary*)deviceNamesByCode {
    
    static NSDictionary* deviceNamesByCode = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        deviceNamesByCode = @{
                              //iPhones
                              
                              @"iPhone3,1" :[NSNumber numberWithInteger:iPhone4],
                              @"iPhone3,3" :[NSNumber numberWithInteger:iPhone4],
                              @"iPhone4,1" :[NSNumber numberWithInteger:iPhone4S],
                              @"iPhone5,1" :[NSNumber numberWithInteger:iPhone5],
                              @"iPhone5,2" :[NSNumber numberWithInteger:iPhone5],
                              @"iPhone5,3" :[NSNumber numberWithInteger:iPhone5C],
                              @"iPhone5,4" :[NSNumber numberWithInteger:iPhone5C],
                              @"iPhone6,1" :[NSNumber numberWithInteger:iPhone5S],
                              @"iPhone6,2" :[NSNumber numberWithInteger:iPhone5S],
                              @"iPhone7,2" :[NSNumber numberWithInteger:iPhone6],
                              @"iPhone7,1" :[NSNumber numberWithInteger:iPhone6Plus],
                              @"i386"      :[NSNumber numberWithInteger:Simulator],
                              @"x86_64"    :[NSNumber numberWithInteger:Simulator],
                              
                              @"iPhone1,1":  [NSNumber numberWithInteger:iPhone1G],
                              @"iPhone1,2":  [NSNumber numberWithInteger:iPhone3G],
                              @"iPhone2,1":  [NSNumber numberWithInteger:iPhone3GS],
                              @"iPhone8,1":  [NSNumber numberWithInteger:iPhone6s],
                              @"iPhone8,2":  [NSNumber numberWithInteger:iPhone6sPlus],
                              
                              @"iPod1,1":    [NSNumber numberWithInteger:iPoTouch1G],
                              @"iPod2,1":    [NSNumber numberWithInteger:iPodTouch2G],
                              @"iPod3,1":    [NSNumber numberWithInteger:iPodTouch3G],
                              @"iPod4,1":    [NSNumber numberWithInteger:iPodTouch4G],
                              @"iPod5,1":    [NSNumber numberWithInteger:iPodTouch5G],
                              
                              
                              //iPads
                              @"iPad1,1" :[NSNumber numberWithInteger:iPad1],
                              @"iPad2,1" :[NSNumber numberWithInteger:iPad1],
                              @"iPad2,2" :[NSNumber numberWithInteger:iPad1],
                              @"iPad2,3" :[NSNumber numberWithInteger:iPad1],
                              @"iPad2,4" :[NSNumber numberWithInteger:iPad1],
                              @"iPad2,5" :[NSNumber numberWithInteger:iPadMini],
                              @"iPad2,6" :[NSNumber numberWithInteger:iPadMini],
                              @"iPad2,7" :[NSNumber numberWithInteger:iPadMini],
                              @"iPad3,1" :[NSNumber numberWithInteger:iPad3],
                              @"iPad3,2" :[NSNumber numberWithInteger:iPad3],
                              @"iPad3,3" :[NSNumber numberWithInteger:iPad3],
                              @"iPad3,4" :[NSNumber numberWithInteger:iPad4],
                              @"iPad3,5" :[NSNumber numberWithInteger:iPad4],
                              @"iPad3,6" :[NSNumber numberWithInteger:iPad4],
                              @"iPad4,1" :[NSNumber numberWithInteger:iPadAir],
                              @"iPad4,2" :[NSNumber numberWithInteger:iPadAir],
                              @"iPad4,4" :[NSNumber numberWithInteger:iPadMiniRetina],
                              @"iPad4,5" :[NSNumber numberWithInteger:iPadMiniRetina]
                              
                              
                              };
    });
    
    return deviceNamesByCode;
}

+(DeviceVersion)deviceVersion {
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *code = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    DeviceVersion version = (DeviceVersion)[[self.deviceNamesByCode objectForKey:code] integerValue];
    
    return version;
    
}

+(DeviceSize)deviceSize {
    
    CGFloat screenHeight = [self deviceScreenSize].height;
    
    if (screenHeight == 480)
        return iPhone35inch;
    else if(screenHeight == 568)
        return iPhone4inch;
    else if(screenHeight == 667)
        return  iPhone47inch;
    else if(screenHeight == 736)
        return iPhone55inch;
    else
        return UnknownSize;
}

+(NSString*)deviceName {
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *code = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([code isEqualToString:@"x86_64"] || [code isEqualToString:@"i386"]) {
        code = @"Simulator";
    }
    
    return code;
}

+ (CGSize)deviceScreenSize
{
    CGSize screenSize;
    
    if (iOSVersionGreaterThan(@"8")) {
        
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        
        if (orientation ==  UIDeviceOrientationPortrait)
        {
            screenSize = [[UIScreen mainScreen] bounds].size;
        }
        else if((orientation == UIDeviceOrientationLandscapeRight)
                || (orientation == UIInterfaceOrientationLandscapeLeft))
        {
            screenSize.width = [[UIScreen mainScreen] bounds].size.height;
            screenSize.height = [[UIScreen mainScreen] bounds].size.width;
        }
    }
    else
    {
        screenSize = [[UIScreen mainScreen] bounds].size;
    }
    
    return screenSize;
}

+(BOOL)isSameWithDeviceSize:(id)deviceSizes
{
    if (deviceSizes == nil) {
        return  NO;
    }
    BOOL isFlag = NO;
    if ([deviceSizes isKindOfClass:[NSArray class]]) {
        NSArray *deviceSizeArr = (NSArray *)deviceSizes;
        if (deviceSizeArr && deviceSizeArr.count > 0) {
            for (int i=0; i<deviceSizeArr.count; i++) {
                isFlag = isFlag || ([[self class] deviceSize] == (DeviceSize)[deviceSizeArr[i] integerValue]) ;
            }
        }
    }else{
        isFlag = ([[self class] deviceSize] ==(DeviceSize)[deviceSizes integerValue]) ;
    }
    
    return isFlag;
}

+(NSString *)deviceType
{
    NSString * deviceTypeStr = [self deviceName];
    if ([[self deviceName] isEqualToString:@"iPhone3,1"]){
        return @"iPhone4";
    }
    else if ([[self deviceName] isEqualToString:@"iPhone3,3"]){
        return @"iPhone4";
    }
    else if ([[self deviceName] isEqualToString:@"iPhone4,1"]){
        return @"iPhone4S";
    }
    else if ([[self deviceName] isEqualToString:@"iPhone5,1"]){
        return @"iPhone5";
    }
    else if ([[self deviceName] isEqualToString:@"iPhone5,2"]){
        return @"iPhone5";
    }
    else if ([[self deviceName] isEqualToString:@"iPhone5,3"]){
        return @"iPhone5C";
    }
    else if ([[self deviceName] isEqualToString:@"iPhone5,4"]){
        return @"iPhone5C";
    }
    else if ([[self deviceName] isEqualToString:@"iPhone6,1"]){
        return @"iPhone5S";
    }
    else if ([[self deviceName] isEqualToString:@"iPhone6,2"]){
        return @"iPhone5S";
    }
    else if ([[self deviceName] isEqualToString:@"iPhone7,2"]){
        return @"iPhone6";
    }
    else if ([[self deviceName] isEqualToString:@"iPhone7,1"]){
        return @"iPhone6Plus";
    }
    else if ([[self deviceName] isEqualToString:@"i386"]){
        return @"Simulator";
    }
    else if ([[self deviceName] isEqualToString:@"x86_64"]){
        return @"Simulator";
    }
    else if ([[self deviceName] isEqualToString:@"iPhone1,1"]){
        return @"iPhone1G";
    }
    else if ([[self deviceName] isEqualToString:@"iPhone1,2"]){
        return @"iPhone3G";
    }
    else if ([[self deviceName] isEqualToString:@"iPhone2,1"]){
        return @"iPhone3GS";
    }
    else if ([[self deviceName] isEqualToString:@"iPhone8,1"]){
        return @"iPhone6s";
    }
    else if ([[self deviceName] isEqualToString:@"iPhone8,2"]){
        return @"iPhone6sPlus";
    }
    else if ([[self deviceName] isEqualToString:@"iPod1,1"]){
        return @"iPoTouch1G";
    }
    else if ([[self deviceName] isEqualToString:@"iPod2,1"]){
        return @"iPodTouch2G";
    }
    else if ([[self deviceName] isEqualToString:@"iPod3,1"]) {
        return @"iPodTouch3G";
    }
    else if ([[self deviceName] isEqualToString:@"iPod4,1"]){
        return @"iPodTouch4G";
    }
    else if ([[self deviceName] isEqualToString:@"iPod5,1"]){
        return @"iPodTouch5G";
    }
    else if ([[self deviceName] isEqualToString:@"iPad1,1"]){
        return @"iPad1";
    }
    else if ([[self deviceName] isEqualToString:@"iPad2,1"]) {
        return @"iPad1";
    }
    else if ([[self deviceName] isEqualToString:@"iPad2,2"]){
        return @"iPad1";
    }
    else if ([[self deviceName] isEqualToString:@"iPad2,3"]){
        return @"iPad1";
    }
    else if ([[self deviceName] isEqualToString:@"iPad2,4"]){
        return @"iPad1";
    }
    else if ([[self deviceName] isEqualToString:@"iPad2,5"]){
        return @"iPadMini";
    }
    else if ([[self deviceName] isEqualToString:@"iPad2,6"]){
        return @"iPadMini";
    }
    else if ([[self deviceName] isEqualToString:@"iPad2,7"]){
        return @"iPadMini";
    }
    else if ([[self deviceName] isEqualToString:@"iPad3,1"]){
        return @"iPad3";
    }
    else if ([[self deviceName] isEqualToString:@"iPad3,2"]){
        return @"iPad3";
    }
    else if ([[self deviceName] isEqualToString:@"iPad3,3"]){
        return @"iPad3";
    }
    else if ([[self deviceName] isEqualToString:@"iPad3,4"]){
        return @"iPad4";
    }
    else if ([[self deviceName] isEqualToString:@"iPad3,5"]){
        return @"iPad4";
    }
    else if ([[self deviceName] isEqualToString:@"iPad3,6"]) {
        return @"iPad4";
    }
    else if ([[self deviceName] isEqualToString:@"iPad4,1"]){
        return @"iPadAir";
    }
    else if ([[self deviceName] isEqualToString:@"iPad4,2"]){
        return @"iPadAir";
    }
    else if ([[self deviceName] isEqualToString:@"iPad4,4"]){
        return @"iPadMiniRetina";
    }
    else if ([[self deviceName] isEqualToString:@"iPad4,5"]) {
        return @"iPadMiniRetina";
    }
    
    return deviceTypeStr;
}
@end
