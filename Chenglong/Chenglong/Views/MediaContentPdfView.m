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
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 300, [UIView screenWidth], [UIView screenWidth])];
    [self addSubview:self.webView];
//    [self.webView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.btnPlay withOffset:Margin];
    
    return self;
}

-(void)play {
    if(![self.localMediaContent isDownloaded]) {
        NSLog(@"no downloaded yet");
        return;
    }
    NSURL* url = [NSURL  fileURLWithPath:self.localMediaContent.filePath];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

@end
