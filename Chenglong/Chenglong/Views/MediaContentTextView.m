//
//  MediaContentTextView.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 8/27/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "MediaContentTextView.h"

@implementation MediaContentTextView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    return self;
}

-(void)play {
    if(!self.webView) {
        self.webView = [UIWebView new];
        [self addSubview:self.webView];
        [self.webView autoPinEdgesToSuperviewMargins];
    }
    NSString* html = self.localMediaContent.content;
    if(![html containsString:@"html"] && ![html containsString:@"HTML"]) {
        html = [html stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
        html = [NSString stringWithFormat:@"<br/><br/>%@",html];
    }
    [self.webView loadHTMLString:html baseURL:nil];
}

@end
