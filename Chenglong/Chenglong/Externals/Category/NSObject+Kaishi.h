//
//  NSObject+Kaishi.h
//  Kaishi
//
//  Created by Rudiney Cardoso on 6/26/15.
//  Copyright (c) 2015 BCGDV. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Kaishi_COMMON_INIT(superInit) \
^id (typeof(self) __self) { \
if (!(__self = superInit)) return nil; \
[__self commonInit]; \
return __self; \
}(self)

@interface NSObject (Kaishi)

- (void)autoGenerateSubview;

- (void)createQueuePoolForTest:(int)test withConcurrentQueue:(int)concurrent andBlock:(void (^)(int index, NSArray *queues))block;

@end
