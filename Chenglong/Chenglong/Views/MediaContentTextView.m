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
    self.webView = [UIWebView new];
    [self addSubview:self.webView];
    [self.webView autoPinEdgesToSuperviewMargins];
    return self;
}

-(void)play {
    NSString* html = self.text;
    if(![self.text containsString:@"html"] && ![self.text containsString:@"HTML"]) {
        html = [html stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
        html = [NSString stringWithFormat:@"<br/><br/>%@",html];
    }
    [self.webView loadHTMLString:html baseURL:nil];
}

-(void)setText:(NSString *)text
{
    _text = text;
    [self play];
}
@end
