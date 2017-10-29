//
//  MediaContentPdfView.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/11/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "MediaContentPdfView.h"

@implementation MediaContentPdfView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    return self;
}

-(void)play {
    WeakSelf(weakSelf)
    if(![self.localMediaContent isDownloaded]) {
        [SVProgressHUD showWithStatus:@"loading ..."];
        [self.localMediaContent downloadWithProgressBlock:^(CGFloat progress) {
            [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"loading %f ... ", progress]];
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

-(void)loadFromLocal {
    if(self.webView == NULL) {
        self.webView = [UIWebView new];
        [self addSubview:self.webView];
        [self.webView autoPinEdgesToSuperviewMargins];
    }
    
    NSURL* url = [NSURL  fileURLWithPath:self.localMediaContent.localFilePath];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
//    WeakSelf(weakSelf)
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPlayEnd object:weakSelf.localMediaContent];
//    });
}

@end
