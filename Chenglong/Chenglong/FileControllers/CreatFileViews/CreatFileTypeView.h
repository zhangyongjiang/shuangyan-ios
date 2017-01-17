//
//  CreatFileTypeView.h
//  Chenglong
//
//  Created by wangyaochang on 2017/1/16.
//  Copyright © 2017年 Chenglong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChooseTypeBlock)(NSInteger index);

@interface CreatFileTypeView : UIView

@property (nonatomic, copy) ChooseTypeBlock chooseTypeBlock;
@end
