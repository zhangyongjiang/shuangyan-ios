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
    
    self.backgroundColor = [UIColor bgColor];
    
    return self;
}

-(void)setEmptyPageText:(NSString *)text {
    UILabel* label = [[UILabel alloc] initWithFrame:self.bounds];
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

-(void)show:(NSString*)name width:(CGFloat)imgw height:(CGFloat)imgh x:(CGFloat)x y:(CGFloat)y toView:(UIView*)view {
}

-(NSButton*)createActionButton:(NSString*)title image:(NSString*)imgname bgcolr:(UIColor*)color{
    CGFloat height = 45;
    CGFloat width = ([UIView screenWidth] - PagePadding * 2 ) * 0.8;
    NSButton* btn = [[NSButton alloc] initWithFrame:CGRectMake(PagePadding, [UIView screenHeight] -height-PagePadding, width, height)];
    [btn styleBook17];
    [self addSubview:btn];
    [btn hcenterInParent];
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateSelected];
    [btn setTitle:title forState:UIControlStateHighlighted];
    
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    return btn;
}

+ (UIImage *)imageWithColor:(UIColor *)color
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


