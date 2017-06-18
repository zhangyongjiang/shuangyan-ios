//
//  PdfView.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/17/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "MediaWebView.h"

@interface PdfView : MediaWebView

@property(strong, nonatomic)MediaContent* mc;

-(id)initWithFrame:(CGRect)frame andMediaContent:(MediaContent*)mc;

@end
