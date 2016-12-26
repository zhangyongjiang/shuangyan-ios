//
//  UIView+Nib.m
//  Foomoo
//
//  Created by QFish on 5/4/14.
//  Copyright (c) 2014 QFish.inc. All rights reserved.
//

#import "UIView+Nib.h"

@implementation UIView (Nib)

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([self class])
                          bundle:[NSBundle mainBundle]];
}

+ (instancetype)loadFromNib
{
    NSArray *nibs =  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil];
    return [nibs firstObject];
}

+ (instancetype)loadFromNibWithFrame:(CGRect)frame
{
    UIView * nibView = [self loadFromNib];
    nibView.frame = frame;
    return nibView;
}


- (void)customize
{
    
}

/**
 * 返回 view的自适应高度
 */
-(CGFloat)returnFitHeight
{
    return 0;
}
@end
