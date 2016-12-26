//
//  FileReferenceHeader.h
//  Chenglong
//
//  Created by wangyaochang on 2016/12/24.
//  Copyright © 2016年 Chenglong. All rights reserved.
//

#ifndef FileReferenceHeader_h
#define FileReferenceHeader_h

#define IS_CLASS(__obj, __class)                          [__obj isKindOfClass:[__class class]]
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define SCREEN_BOUNDS_SIZE [UIScreen mainScreen].bounds.size
#define SCREEN_BOUNDS_SIZE_WIDTH SCREEN_BOUNDS_SIZE.width
#define SCREEN_BOUNDS_SIZE_HEIGHT SCREEN_BOUNDS_SIZE.height

#define WeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define PageSize 20

#endif /* FileReferenceHeader_h */
