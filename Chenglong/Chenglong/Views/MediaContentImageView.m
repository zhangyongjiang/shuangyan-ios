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
    self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.imgView = [UIImageView new];
    [self.imgView setContentMode:UIViewContentModeScaleAspectFill];
    [self addSubview:self.imgView];

    CGFloat size = 60;
    UIImageView* btnFullScreen = [UIImageView new];
    btnFullScreen.contentMode = UIViewContentModeScaleAspectFit;
    btnFullScreen.image = [UIImage imageNamed:@"ic_fullscreen"];
    [self addSubview:btnFullScreen];
    [btnFullScreen autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [btnFullScreen autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [btnFullScreen autoSetDimensionsToSize:CGSizeMake(size, size)];
    [btnFullScreen addTarget:self action:@selector(toggleFullscreen)];
    
    return self;
}

-(void)toggleFullscreen
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationFullscreen object:nil];
}

-(void)play {
    if(![self.courseDetails.course.localMediaContent isDownloaded]) {
        WeakSelf(weakSelf)
        [SVProgressHUD showWithStatus:@"loading ..."];
        [self.courseDetails.course.localMediaContent downloadWithProgressBlock:^(CGFloat progress) {
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
    UIImage* img = [UIImage imageWithContentsOfFile:self.courseDetails.course.localMediaContent.localFilePath];
    self.imgView.image = img;
    [self layoutSubviews];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPlayStart object:self.courseDetails];
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

@end
