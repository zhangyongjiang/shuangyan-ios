//
//  RemindBlankView.m
//  Kaishi
//
//  Created by wangyaochang on 16/9/2.
//  Copyright © 2016年 BCGDV. All rights reserved.
//

#import "RemindBlankView.h"

@interface RemindBlankView ()

{
    CGFloat defaultTopConstraint;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgTopContraint;
@property (weak, nonatomic) IBOutlet UILabel *lbContent;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lbContentTopContraint;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *btnTap;

@property (nonatomic, assign) CGFloat imgTopContraintValue;
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) NSString *message;
@property (nonatomic, assign) BOOL btnShow;

@end

@implementation RemindBlankView

+ (RemindBlankView *)loadWithImgTopValue:(CGFloat)value message:(NSString *)msg image:(UIImage *)img
{
    RemindBlankView *remindView = [RemindBlankView loadFromNib];
    remindView.imgTopContraintValue = value;
    remindView.message = msg;
    remindView.image = img;
    return remindView;
}

- (void)setupBtnShow:(BOOL)isShow title:(NSString *)title tap:(BtnBlankTapBlock)tapBlock
{
    _btnShow = isShow;
    _btnTap.hidden = !isShow || _isLoading;
    [_btnTap setTitle:title?:@"" forState:UIControlStateNormal];
    CGFloat imgTopValue = _imgTopContraintValue>0?_imgTopContraintValue:(_btnShow?(defaultTopConstraint - 40.f):defaultTopConstraint);
    _imgTopContraint.constant = imgTopValue;
    _lbContentTopContraint.constant = _isLoading ? imgTopValue:(imgTopValue + 90.f + 10.f);
    [self setNeedsUpdateConstraints];
    [self layoutIfNeeded];
    if (tapBlock) {
        self.tapBlock = tapBlock;
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self layoutIfNeeded];
    _lbContent.preferredMaxLayoutWidth = SCREEN_BOUNDS_SIZE_WIDTH - 50.f*2;
    _lbContent.font = [UIFont type:UIFontTypeLight size:16.f];
    _activityView.hidden = YES;
    
    [_btnTap setBackgroundColor:[UIColor kaishiColor:UIColorTypeThemeSelected]];
    _btnTap.titleLabel.font = [UIFont type:UIFontTypeLight size:15.f];
    _btnTap.layer.cornerRadius = CGRectGetHeight(_btnTap.bounds)/2;
    _btnTap.layer.masksToBounds = YES;
    
    defaultTopConstraint = SCREEN_BOUNDS_SIZE_HEIGHT/2 - 32.f - 90.f;//默认距离顶部是 中心高度 - 导航一半 - 图片高度
}

- (void)setIsLoading:(BOOL)isLoading
{
    _isLoading = isLoading;
    _imgView.hidden = _isLoading;
    _btnTap.hidden = !_btnShow || _isLoading;
    _lbContent.text = _isLoading ? @"加载中…" : _message;
    
    CGFloat imgTopValue = _imgTopContraintValue>0?_imgTopContraintValue:(_btnShow?(defaultTopConstraint - 40.f):defaultTopConstraint);
    _imgTopContraint.constant = imgTopValue;
    _lbContentTopContraint.constant = _isLoading ? imgTopValue:(imgTopValue + 90.f + 10.f);
    if (_image) {
        _imgView.image = _image;
    }
    if (_isLoading) {
        [_activityView startAnimating];
    }else{
        [_activityView stopAnimating];
    }
    [self setNeedsUpdateConstraints];
    [self layoutIfNeeded];
}
- (IBAction)btnTapEvent:(id)sender
{
    if (self.tapBlock) {
        self.tapBlock();
    }
}
@end
