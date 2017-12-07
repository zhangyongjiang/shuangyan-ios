//
//  MediaContentTextView.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 8/27/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "MediaContentTextView.h"
#import "ButtonPrev.h"
#import "ButtonNext.h"
#import "ButtonFullscreen.h"

@implementation MediaContentTextView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);

    self.webView = [UIWebView new];
    [self addSubview:self.webView];
    [self.webView autoPinEdgesToSuperviewMargins];

    [ButtonFullscreen createBtnInSuperView:self withIcon:@"ic_fullscreen"];
    [ButtonPrev createBtnInSuperView:self withIcon:@"ic_skip_previous"];
    [ButtonNext createBtnInSuperView:self withIcon:@"ic_skip_next"];

    return self;
}

-(void)toggleFullscreen
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationFullscreen object:nil];
}

-(void)play {
    NSString* html = self.courseDetails.course.content;
    if(![html containsString:@"html"] && ![html containsString:@"HTML"]) {
        html = [html stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
        html = [NSString stringWithFormat:@"<br/><br/>%@",html];
    }
    [self.webView loadHTMLString:html baseURL:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPlayStart object:self.courseDetails];
}

@end
