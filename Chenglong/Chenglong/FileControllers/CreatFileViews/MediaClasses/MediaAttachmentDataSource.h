//
//  MediaAttachmentDataSource.h
//  Chenglong
//
//  Created by wangyaochang on 2017/1/16.
//  Copyright © 2017年 Chenglong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MediaAttachmentDataSource : NSObject <UICollectionViewDataSource>

@property (nonatomic, weak) UIViewController *parentViewController;
@property (nonatomic, assign) NSInteger photoMaxNum;
@property (nonatomic, strong) NSMutableArray *attachments;

- (id)initWithOwner:(id)owner;

@end
