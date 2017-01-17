//
//  MediaAttachmentCollectionViewCell.h
//  Chenglong
//
//  Created by wangyaochang on 2017/1/16.
//  Copyright © 2017年 Chenglong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MediaAttachment.h"


@interface MediaAttachmentCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, assign) BOOL isDefaultAttachmentOption;

- (void)setAttachment:(MediaAttachment *)attachment;

@end
