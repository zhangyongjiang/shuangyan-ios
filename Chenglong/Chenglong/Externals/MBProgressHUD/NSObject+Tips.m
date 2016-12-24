//
//  NSObject+Tips.m
//  Foomoo
//
//  Created by QFish on 6/6/14.
//  Copyright (c) 2014 QFish.inc. All rights reserved.
//

#import "NSObject+Tips.h"

__weak MBProgressHUD * _sharedHud;

@implementation UIView (Tips)

- (MBProgressHUD *)showTips:(NSString *)message autoHide:(BOOL)autoHide
{
    UIView * container = self;
    
    if ( container )
    {
        if ( nil != _sharedHud )
        {
            [_sharedHud hide:NO];
        }
        
        UIView * view = self;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = message;
		hud.detailsLabelFont = [UIFont systemFontOfSize:15];
        _sharedHud = hud;
        
        if ( autoHide )
        {
            [hud hide:YES afterDelay:2.f];
        }
    }
    
    return _sharedHud;
}

- (MBProgressHUD *)presentMessageTips:(NSString *)message
{
    return [self showTips:message autoHide:YES];
}

- (MBProgressHUD *)presentSuccessTips:(NSString *)message
{
    return [self showTips:message autoHide:YES];
}

- (MBProgressHUD *)presentFailureTips:(NSString *)message
{
    return [self showTips:message autoHide:YES];
}

- (MBProgressHUD *)showTipsWithYOffset:(NSString *)message autoHide:(BOOL)autoHide
{
    UIView * container = self;
    
    if ( container )
    {
        if ( nil != _sharedHud )
        {
            [_sharedHud hide:NO];
        }
        
        UIView * view = self;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = message;
        hud.detailsLabelFont = [UIFont systemFontOfSize:15];
        hud.yOffset -= 50;
        _sharedHud = hud;
        
        if ( autoHide )
        {
            [hud hide:YES afterDelay:2.f];
        }
    }
    
    return _sharedHud;
}

- (MBProgressHUD *)presentLoadingTips:(NSString *)message
{
    UIView * container = self;
    
    if ( container )
    {
        if ( nil != _sharedHud )
        {
            [_sharedHud hide:NO];
        }
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:container animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.detailsLabelText = message;
        hud.detailsLabelFont = [UIFont systemFontOfSize:15];
        _sharedHud = hud;
    }

    return _sharedHud;
}

- (MBProgressHUD *)presentRightIconTips:(NSString *)message
{
    UIView * container = self;
    
    if ( container )
    {
        if ( nil != _sharedHud )
        {
            [_sharedHud hide:NO];
        }
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:container animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.detailsLabelText = message;
        hud.detailsLabelFont = [UIFont systemFontOfSize:15];
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tip_right_icon"]];
        _sharedHud = hud;
        [hud hide:YES afterDelay:2.f];
    }
    
    return _sharedHud;
}

- (void)dismissTips
{
    [_sharedHud hide:YES];
    _sharedHud = nil;
}

@end

@implementation UIViewController (Tips)

- (MBProgressHUD *)presentMessageTips:(NSString *)message
{
    return [self.view showTips:message autoHide:YES];
}

- (MBProgressHUD *)presentSuccessTips:(NSString *)message
{
    return [self.view showTips:message autoHide:YES];
}

- (MBProgressHUD *)presentFailureTips:(NSString *)message
{
    return [self.view showTips:message autoHide:YES];
}

- (MBProgressHUD *)presentFailureTipsWithYOffset:(NSString *)message
{
    return [self.view showTipsWithYOffset:message autoHide:YES];
}

- (MBProgressHUD *)presentLoadingTips:(NSString *)message
{
    return [self.view presentLoadingTips:message];
}

- (void)dismissTips
{
    [self.view dismissTips];
}

- (MBProgressHUD *)presentRightIconTips:(NSString *)message
{
    return [self.view presentRightIconTips:message];
}

@end
