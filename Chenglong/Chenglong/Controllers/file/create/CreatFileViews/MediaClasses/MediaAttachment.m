//
//  JournalAttachment.m
//  Chenglong
//
//  Created by wangyaochang on 2017/1/16.
//  Copyright © 2017年 Chenglong. All rights reserved.
//

#import "MediaAttachment.h"


@implementation MediaAttachment

#pragma mark - init

- (id)initWithDefaultType:(FileMediaType)type {
    self = [super init];
    
    _type = type;
    
    switch (type) {
        case FileMediaTypeAdd:
            _coverPhoto = [UIImage imageNamed:@"file_creat_addmedia"];
            break;
        default:
            break;
    }
    
    return self;
}


@end
