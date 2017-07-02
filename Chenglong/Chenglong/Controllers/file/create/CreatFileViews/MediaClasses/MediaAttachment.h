//
//  JournalAttachment.h
//  Chenglong
//
//  Created by wangyaochang on 2017/1/16.
//  Copyright © 2017年 Chenglong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MediaAttachment : NSObject

@property (nonatomic, assign) FileMediaType type;
@property (nonatomic, strong) NSData *media;
@property (nonatomic, strong) UIImage *coverPhoto;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSNumber *value;

- (id)initWithDefaultType:(FileMediaType)type;

@end
