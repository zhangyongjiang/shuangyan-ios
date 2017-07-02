//
//  FilesChooseTitleView.m
//  Chenglong
//
//  Created by wangyaochang on 2016/12/29.
//  Copyright © 2016年 Chenglong. All rights reserved.
//

#import "FilesChooseTitleView.h"

@interface FilesChooseTitleView ()

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@end

@implementation FilesChooseTitleView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.tapTitleBlock) {
        self.tapTitleBlock();
    }
}

- (void)setupImgIconDirection:(BOOL)isUp
{
    [UIView animateWithDuration:.25 animations:^{
        _imgIcon.transform = isUp ? CGAffineTransformRotate(CGAffineTransformIdentity, M_PI) : CGAffineTransformIdentity;
    }];
}
- (void)setupTitle:(NSString *)title
{
    _lbTitle.text = title;
}
@end
