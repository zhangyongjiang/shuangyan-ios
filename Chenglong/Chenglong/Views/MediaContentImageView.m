//
//  MediaContentImageView.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/10/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "MediaContentImageView.h"
#import "ImageViewController.h"

@implementation MediaContentImageView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor blackColor];
    return self;
}

-(void)play {
    if(![self.localMediaContent isDownloaded]) {
        WeakSelf(weakSelf)
        [SVProgressHUD showWithStatus:@"loading ..."];
        [self.localMediaContent downloadWithProgressBlock:^(CGFloat progress) {
            [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"loading %0.2f%% ... ", progress*100.]];
        } completionBlock:^(BOOL completed) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf loadFromLocal];
                [SVProgressHUD dismiss];
            });
        }];
        return;
    }
    [self loadFromLocal];
}

-(void)loadFromLocal
{
    if(self.imgView == NULL) {
        self.imgView = [UIImageView new];
        [self.imgView setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:self.imgView];
        //        [self.imgView autoPinEdgesToSuperviewMargins];
    }
    
    UIImage* img = [UIImage imageWithContentsOfFile:self.localMediaContent.localFilePath];
    self.imgView.image = img;
    [self layoutSubviews];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    UIImage* img = self.imgView.image;
    if(img == NULL)
        return;
    if(img.size.width/img.size.height > self.width/self.height) {
        CGFloat w = self.width;
        CGFloat h = w * img.size.height / img.size.width;
        CGFloat y = (self.height - h)/2.;
        self.imgView.frame = CGRectMake(0, y, w, h);
    }
    else {
        CGFloat h = self.height;
        CGFloat w = h * img.size.width / img.size.height;
        CGFloat x = (self.width - w)/2.;
        self.imgView.frame = CGRectMake(x, 0, w, h);
    }
}

-(void)setLocalMediaContent:(LocalMediaContent *)mediaContent {
    [super setLocalMediaContent:mediaContent];
    if([mediaContent isDownloaded])
        self.btnDownload.hidden = YES;
}

@end
