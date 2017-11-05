//
//  MediaContentPdfView.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/11/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "MediaContentPdfView.h"

@interface MediaContentPdfView() <UIWebViewDelegate>
@end

@implementation MediaContentPdfView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);

    self.webView = [[UIWebView alloc] initWithFrame:self.bounds];
    self.webView.scalesPageToFit = NO;
    self.webView.delegate = self;
    [self addSubview:self.webView];
    
//    auto layout will cause display issue.
//    [self.webView autoPinEdgesToSuperviewMargins];

    return self;
}

-(void)play {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPlayStart object:self.courseDetails];
    BOOL remote = NO;
    if(remote) {
        NSString* str = self.courseDetails.course.localMediaContent.url;
        str = [AppDelegate appendAccessTokenToUrl:str];
        NSURL* url = [NSURL URLWithString:str];
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
        return;
    }
    WeakSelf(weakSelf)
    if(![self.courseDetails.course.localMediaContent isDownloaded]) {
        [SVProgressHUD showWithStatus:@"下载 ..."];
        [self.courseDetails.course.localMediaContent downloadWithProgressBlock:^(CGFloat progress) {
            [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"下载 %.01f%%", progress*100]];
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
    NSURL* url = [NSURL  fileURLWithPath:self.courseDetails.course.localMediaContent.localFilePath];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad %@", webView.request.URL);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webViewDidStartLoad %@", webView.request.URL);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Error : %@",error);
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.webView.frame = self.bounds;
}
@end
