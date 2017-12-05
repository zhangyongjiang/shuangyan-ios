//
//  Data.m
//  NextShopper
//
//  Created by Kevin Zhang on 12/23/13.
//  Copyright (c) 2013 Gaoshin. All rights reserved.
//

#import "NSString+Json.h"
#import <objc/runtime.h>
#import "ObjectMapper.h"
#import "Data.h"

@implementation Data : NSObject

-(void)encodeWithCoder:(NSCoder *)encoder
{
    unsigned int count = 0;
    Ivar * ivars = class_copyIvarList([self class], &count);
    
    for (int i = 0; i<count; i++) {
        
        // 取出i位置对应的成员变量
        Ivar ivar = ivars[i];
        
        // 查看成员变量
        const char *name = ivar_getName(ivar);
        
        // 归档
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        [encoder encodeObject:value forKey:key];
    }
    
    free(ivars);
}
-(id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([self class], &count);
        
        for (int i = 0; i<count; i++) {
            // 取出i位置对应的成员变量
            Ivar ivar = ivars[i];
            
            // 查看成员变量
            const char *name = ivar_getName(ivar);
            
            // 归档
            NSString *key = [NSString stringWithUTF8String:name];
            id value = [decoder decodeObjectForKey:key];
            
            // 设置到成员变量身上
            [self setValue:value forKey:key];
        }
        
        free(ivars);
    }
    return self;
}

-(NSString *) toJson
{
    return [NSString jsonStringWithDictionary:[self toDictionary]];
}

- (NSMutableDictionary *) toDictionary
{
    
    Class clazz = [self class];
    u_int count;
    
    objc_property_t* properties = class_copyPropertyList(clazz, &count);
    NSMutableArray* propertyArray = [NSMutableArray arrayWithCapacity:count];
    NSMutableArray* valueArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count ; i++)
    {
        objc_property_t prop=properties[i];
        const char* propertyName = property_getName(prop);
        NSString* sname = [NSString stringWithUTF8String:propertyName];
        id value =  [self performSelector:NSSelectorFromString(sname)];
        if(value !=nil){
            [propertyArray addObject:[NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
            if ([value isKindOfClass:[Data class]]) {
                Data* data = (Data*)value;
                [valueArray addObject:[data toDictionary]];
            }
            else if ([value isKindOfClass:[NSArray class]]) {
                NSArray* items = (NSArray*)value;
                NSMutableArray* converted = [[NSMutableArray alloc] init];
                for (NSObject* item in items) {
                    if ([item isKindOfClass:[Data class]]) {
                        Data* data = (Data*)item;
                        [converted addObject:[data toDictionary]];
                    }
                    else if ([item isKindOfClass:[NSString class]]) {
                        NSString* data = (NSString*)item;
                        [converted addObject:data];
                    }
                }
                [valueArray addObject:converted];
            }
            else {
                [valueArray addObject:value];
            }
        }
    }
    free(properties);
    NSMutableDictionary* dtoDic = [NSMutableDictionary dictionaryWithObjects:valueArray forKeys:propertyArray];
    return dtoDic;
}

-(NSString*)urlEscapeString:(NSString *)unencodedString
{
    CFStringRef originalStringRef = (__bridge_retained CFStringRef)unencodedString;
    NSString *s = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,originalStringRef, NULL, NULL,kCFStringEncodingUTF8);
    CFRelease(originalStringRef);
    return s;
}

-(NSString*)addToUrlString:(NSString *)urlString
{
    NSDictionary *dictionary = [self toDictionary];
    [dictionary setValue:@"json" forKey:@"format"];
    NSMutableString *urlWithQuerystring = [[NSMutableString alloc] initWithString:urlString];
    
    for (id key in dictionary) {
        NSString *keyString = [key description];
        NSString *valueString = [[dictionary objectForKey:key] description];
        
        if ([urlWithQuerystring rangeOfString:@"?"].location == NSNotFound) {
            [urlWithQuerystring appendFormat:@"?%@=%@", [self urlEscapeString:keyString], [self urlEscapeString:valueString]];
        } else {
            [urlWithQuerystring appendFormat:@"&%@=%@", [self urlEscapeString:keyString], [self urlEscapeString:valueString]];
        }
    }
    return urlWithQuerystring;
}
@end
