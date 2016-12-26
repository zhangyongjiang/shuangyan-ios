//
//  UCActionSheet.h
//  PhotoFlow
//
//  Created by WangYaochang on 16/3/2.
//  Copyright © 2016年 jijunyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^UCActionViewBlock)(NSInteger index);

@interface UCActionSheet : UIActionSheet <UIActionSheetDelegate>

@property (nonatomic, copy) UCActionViewBlock whenDidSelecButton;

@end
