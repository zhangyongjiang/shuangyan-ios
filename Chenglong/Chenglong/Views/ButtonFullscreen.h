//
//  ButtonFullscreen.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 12/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonFullscreen : UIImageView

+(ButtonFullscreen*)createBtnInSuperView:(UIView*)parent withIcon:(NSString*)imageName;

@end
