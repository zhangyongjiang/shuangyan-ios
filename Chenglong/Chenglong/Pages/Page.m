//
//  Page.m
//
//
//  Created by Kevin Zhang on 11/16/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

#import "Page.h"

@interface Page()
{
    UIView* _emptyView;
}
@end

@implementation Page

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    self.backgroundColor = [UIColor whiteColor];
    
    return self;
}

-(void)setEmptyPageText:(NSString *)text {
    UILabel* label = [[UILabel alloc] initWithFrame:self.bounds];
    label.height = [UIView screenHeight]*0.8;
    label.width = label.width * 0.68;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    [self setEmptyPageView:label];
}

-(void)setEmptyPageView:(UIView *)view {
    if(_emptyView)
        [_emptyView removeFromSuperview];
    _emptyView = view;
    [self addSubview:_emptyView];
    [_emptyView centerInParent];
}

-(void)reload {
}

-(void)beginRefresh {
}

-(void)endRefresh {
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end


