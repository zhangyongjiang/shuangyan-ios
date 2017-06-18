//
//  AudioView.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/17/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "AudioView.h"

@implementation AudioView

-(id)initWithFrame:(CGRect)frame andMediaContent:(MediaContent*)mc{
    self = [super initWithFrame:frame];
    self.mc = mc;
    NSString* html = [NSString stringWithFormat:@"<audio style='width:100%%,height:100%%;' controls> <source src='%@' type='%@'>Your browser does not support the video tag.</audio>", mc.url, mc.contentType];
    [self loadHTMLString:html baseURL:nil];
    return self;
}

@end
