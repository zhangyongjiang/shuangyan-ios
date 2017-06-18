//
//  PdfView.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/17/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "PdfView.h"

@implementation PdfView

-(id)initWithFrame:(CGRect)frame andMediaContent:(MediaContent*)mc{
    self = [super initWithFrame:frame];
    self.mc = mc;

    NSURL* url = [NSURL URLWithString:mc.url];
    [self loadRequest:[NSURLRequest requestWithURL:url]];
    
    return self;
}

@end
