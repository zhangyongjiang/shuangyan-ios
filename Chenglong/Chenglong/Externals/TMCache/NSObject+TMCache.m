//
//  NSObject+TMCache.m
//  vogue
//
//  Created by PURPLEPENG on 11/13/14.
//  Copyright (c) 2014 geekzoo. All rights reserved.
//

#import "NSObject+TMCache.h"
#import "TMCache.h"

@implementation NSObject (TMCache)

- (void)tm_setObject:(id <NSCoding>)object forKey:(NSString *)key
{
    return [[self class] tm_setObject:object forKey:key];
}

+ (void)tm_setObject:(id)object forKey:(NSString *)key
{
    if ( !object )
        return;
    
    NSParameterAssert( [object respondsToSelector:@selector(initWithCoder:)] && [object respondsToSelector:@selector(encodeWithCoder:)] );
    
    [[TMCache sharedCache].diskCache setObject:(id<NSCoding>)object forKey:key];
}

- (id <NSCoding>)tm_objectForKey:(NSString *)key
{
    return [[self class] tm_objectForKey:key];
}

+ (id)tm_objectForKey:(NSString *)key
{
    return [[TMCache sharedCache].diskCache objectForKey:key];
}

- (void)tm_removeObjectForKey:(NSString *)key
{
    return [[self class] tm_removeObjectForKey:key];
}

+ (void)tm_removeObjectForKey:(NSString *)key
{
    [[TMCache sharedCache].diskCache removeObjectForKey:key];
}

@end
