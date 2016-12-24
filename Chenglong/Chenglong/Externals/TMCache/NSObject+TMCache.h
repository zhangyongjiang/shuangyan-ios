//
//  NSObject+TMCache.h
//  vogue
//
//  Created by PURPLEPENG on 11/13/14.
//  Copyright (c) 2014 geekzoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (TMCache)

- (id)tm_objectForKey:(NSString *)key;
+ (id)tm_objectForKey:(NSString *)key;
- (void)tm_setObject:(id)object forKey:(NSString *)key;
+ (void)tm_setObject:(id)object forKey:(NSString *)key;
- (void)tm_removeObjectForKey:(NSString *)key;
+ (void)tm_removeObjectForKey:(NSString *)key;

@end
