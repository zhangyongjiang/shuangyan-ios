//
//  FDAlertView.m
//  Fadein
//
//  Created by PURPLEPENG on 1/13/15.
//  Copyright (c) 2015 Arceus. All rights reserved.
//

#import "FDAlertView.h"

@implementation FDAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    if ( self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles,nil])
    {
        
    }
    return self;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( 0 == buttonIndex )
    {
        if ( self.whenDidSelectCancelButton )
        {
            self.whenDidSelectCancelButton();
        }
    }
    else
    {
        if ( self.whenDidSelectOtherButton )
        {
            self.whenDidSelectOtherButton();
        }
    }
}

@end
