//
//  CourseFolderCell.m
//  Chenglong
//
//  Created by wangyaochang on 2017/1/8.
//  Copyright © 2017年 Chenglong. All rights reserved.
//

#import "CourseFolderCell.h"

@interface CourseFolderCell ()

@property (weak, nonatomic) IBOutlet UIButton *btnFileSected;
@property (weak, nonatomic) IBOutlet UILabel *lbFileName;

@end

@implementation CourseFolderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
