//
//  FilesChooseTitleView.h
//  Chenglong
//
//  Created by wangyaochang on 2016/12/29.
//  Copyright © 2016年 Chenglong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilesChooseTitleView : UIView

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (nonatomic, copy) BlankBlock tapTitleBlock;

- (void)setupImgIconDirection:(BOOL)isUp;
@end
