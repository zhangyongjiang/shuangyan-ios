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
    WeakSelf(weakSelf)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPlayEnd object:weakSelf.localMediaContent];
    });
}

@end
