//
//  ButtonLockScreen.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 12/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonLockScreen : UIImageView

+(ButtonLockScreen*)createBtnInSuperView:(UIView*)parent withIcon:(NSString*)imageName;

@end
