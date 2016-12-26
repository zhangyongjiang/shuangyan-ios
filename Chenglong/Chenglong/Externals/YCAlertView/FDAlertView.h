//
//  FDAlertView.h
//  Fadein
//
//  Created by PURPLEPENG on 1/13/15.
//  Copyright (c) 2015 Arceus. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FDAlertViewBlock)(void);

@interface FDAlertView : UIAlertView<UIAlertViewDelegate>

@property (nonatomic, copy) FDAlertViewBlock whenDidSelectCancelButton;
@property (nonatomic, copy) FDAlertViewBlock whenDidSelectOtherButton;

@end
