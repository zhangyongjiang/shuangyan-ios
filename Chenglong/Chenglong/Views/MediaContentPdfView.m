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
    if(![self.mediaContent isDownloaded]) {
        NSLog(@"no downloaded yet");
        return;
    }

    if(self.webView == NULL) {
        self.webView = [UIWebView new];
        [self addSubview:self.webView];
        [self.webView autoPinEdgesToSuperviewMargins];
    }

    NSURL* url = [NSURL  fileURLWithPath:self.mediaContent.filePath];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

@end
