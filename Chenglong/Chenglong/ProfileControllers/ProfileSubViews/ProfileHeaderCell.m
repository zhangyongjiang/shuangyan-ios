//
//  ProfileHeaderCell.m
//  Chenglong
//
//  Created by wangyaochang on 2017/1/8.
//  Copyright © 2017年 Chenglong. All rights reserved.
//

#import "ProfileHeaderCell.h"

@interface ProfileHeaderCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgHeader;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbScoreNum;

@end

@implementation ProfileHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dataDidChange
{
    User *user = self.data;
    [_imgHeader sd_setImageWithURL:[NSURL URLWithString:user.imgPath] placeholderImage:kDefaultHeaderImg];
    _lbName.text = user.name;
//    _lbScoreNum.text = user. 
}
@end
