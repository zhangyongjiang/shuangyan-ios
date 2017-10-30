//
//  MediaContentPdfView.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/11/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "MediaContentPdfView.h"

@interface MediaContentPdfView()
@end

@implementation MediaContentPdfView

-(id)initWithFrame:(CGRect)frame {
    CGFloat size = 60;
    self = [super initWithFrame:frame];
    self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);

    self.webView = [UIWebView new];
    self.webView.scalesPageToFit = YES;
    [self addSubview:self.webView];
    [self.webView autoPinEdgesToSuperviewMargins];

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
    BOOL remote = YES;
    if(remote) {
        NSString* str = self.localMediaContent.url;
        str = [AppDelegate appendAccessTokenToUrl:str];
        NSURL* url = [NSURL URLWithString:str];
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
        return;
    }
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
    NSURL* url = [NSURL  fileURLWithPath:self.localMediaContent.localFilePath];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

@end
