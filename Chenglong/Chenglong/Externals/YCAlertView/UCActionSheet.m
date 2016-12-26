//
//  UCActionSheet.m
//  PhotoFlow
//
//  Created by WangYaochang on 16/3/2.
//  Copyright © 2016年 jijunyuan. All rights reserved.
//

#import "UCActionSheet.h"

@implementation UCActionSheet

#pragma mark - UIAlertViewDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.whenDidSelecButton) {
        self.whenDidSelecButton(buttonIndex);
    }
}
@end
