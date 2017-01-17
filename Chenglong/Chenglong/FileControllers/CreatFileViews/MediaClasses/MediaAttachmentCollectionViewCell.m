//
//  MediaAttachmentCollectionViewCell.m
//  Chenglong
//
//  Created by wangyaochang on 2017/1/16.
//  Copyright © 2017年 Chenglong. All rights reserved.
//

#import "MediaAttachmentCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MediaAttachmentCollectionViewCell ()

@property (nonatomic, assign) FileMediaType mediaType;
@end

@implementation MediaAttachmentCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        _imageView = [UIImageView newAutoLayoutView];
        _imageView.backgroundColor = [UIColor whiteColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.cornerRadius = 8.0;
        _imageView.clipsToBounds = YES;
        [self.contentView addSubview:_imageView];
        
        _textLabel = [UILabel newAutoLayoutView];
        _textLabel.text = @"";
        _textLabel.font = [UIFont type:UIFontTypeLight size:32.0];
        _textLabel.textColor = [UIColor themeColor:UIColorTypePrimary];
        [self.contentView addSubview:_textLabel];
        
        _deleteButton = [UIButton newAutoLayoutView];
        _deleteButton.backgroundColor = [UIColor colorFromHex:0xd8d3cd];
        [_deleteButton setTitle:nil forState:UIControlStateNormal];
        [_deleteButton setImage:[[UIImage imageNamed:@"file_media_delete"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        _deleteButton.tintColor = [UIColor themeColor:UIColorTypePrimary];
        _deleteButton.layer.cornerRadius = 9.0;
        _deleteButton.clipsToBounds = YES;
        [self.contentView addSubview:_deleteButton];
        
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
    }
    
    return self;
}

- (void)updateConstraints {
    
    [self.imageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(4.0, 0.0, 0.0, 4.0)];
    
    [self.textLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.imageView withOffset:16.0];
    [self.textLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:self.imageView];
    
    [self.deleteButton autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.deleteButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.deleteButton autoSetDimensionsToSize:CGSizeMake(18.0, 18.0)];
    
    [super updateConstraints];
}

- (void)setAttachment:(MediaAttachment *)attachment {
    if (attachment.coverPhoto) {
        self.imageView.image = attachment.coverPhoto;
        
    } else if (attachment.url) {
        [self.imageView sd_setImageWithURL:attachment.url placeholderImage:[UIImage imageNamed:@"header_default_img"] options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            attachment.media = UIImageJPEGRepresentation(image, [Config shared].defaultImageQuality);
            attachment.coverPhoto = image;
        }];
    }
    
    _mediaType = attachment.type;
    [self setNeedsUpdateConstraints];
}

- (void)setIsDefaultAttachmentOption:(BOOL)isDefaultAttachmentOption {
    _isDefaultAttachmentOption = isDefaultAttachmentOption;
    
    if (self.isDefaultAttachmentOption) {
        self.textLabel.text = @"";
        self.deleteButton.hidden = YES;
    } else {
        self.deleteButton.hidden = NO;
    }
    
    [self setNeedsUpdateConstraints];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.textLabel.text = @"";
    [self.deleteButton bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    
    self.imageView.layer.borderColor = [UIColor clearColor].CGColor;
    self.imageView.layer.borderWidth = 0.0;
}


@end
