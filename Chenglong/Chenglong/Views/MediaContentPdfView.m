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
}
@end
