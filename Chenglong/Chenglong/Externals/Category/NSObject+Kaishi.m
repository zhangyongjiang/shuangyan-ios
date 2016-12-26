//
//  NSObject+Kaishi.m
//  Kaishi
//
//  Created by Rudiney Cardoso on 6/26/15.
//  Copyright (c) 2015 BCGDV. All rights reserved.
//

#import "NSObject+Kaishi.h"
#import <objc/runtime.h>

@implementation NSObject (Kaishi)

- (void)autoGenerateSubview {
    
    unsigned count;
    objc_property_t* properties = class_copyPropertyList([self class], &count);
    
    for (int i = 0; i < count ; i++)
    {
        objc_property_t property=properties[i];
        
        const char * name = property_getName(property);
        const char * type = property_getAttributes(property);

        NSString * nameProperty = [NSString stringWithUTF8String:name];

        NSString * typeString = [NSString stringWithUTF8String:type];
        NSArray * attributes = [typeString componentsSeparatedByString:@","];
        NSString * typeAttribute = [attributes objectAtIndex:0];
        
        if ([typeAttribute hasPrefix:@"T@"]) {
            NSString * className = [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length]-4)];
            id class = NSClassFromString(className);
            id object = [class new];

            if (object != nil && [object isKindOfClass:[UIView class]]) {
                property = (__bridge objc_property_t)(object);
                [self setValue:object forKey:nameProperty];
                
                UIView *view = (UIView*)object;
                view.translatesAutoresizingMaskIntoConstraints=NO;
                
                if ([self isKindOfClass:[UIViewController class]]) {
                    UIViewController *viewController = (UIViewController*)self;
                    [viewController.view addSubview:(__bridge UIView *)(property)];
                }
                else if ([self isKindOfClass:[UIView class]]) {
                    UIView *view = (UIView*)self;
                    [view addSubview:(__bridge UIView *)(property)];
                }
                if ([object respondsToSelector:@selector(delegate)]) {
                    [object setValue:self forKey:@"delegate"];
                }
            }
        }
    }
    free(properties);
}

- (void)createQueuePoolForTest:(int)test withConcurrentQueue:(int)concurrent andBlock:(void (^)(int index, NSArray *queues))block {
    
    //used to create a concurrent stress test
    
    dispatch_group_t group = dispatch_group_create();
    
    NSMutableArray *queues = [NSMutableArray arrayWithCapacity:concurrent];
    for (int x = 0; x < concurrent; x++)
    {
        char queueName[20];
        sprintf(queueName, "Queue%d", x);
        queues[x] = dispatch_queue_create(queueName, NULL);
    }
    
    for (int x = 0; x < concurrent; x++)
    {
        dispatch_group_async(group, queues[x], ^{
            
            for (int y = 0; y<ceil(test/concurrent)-1; y++) {
                block(x,queues);
            }
        });
    }
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
}

@end
