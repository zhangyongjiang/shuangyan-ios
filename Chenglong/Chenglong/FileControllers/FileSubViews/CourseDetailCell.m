//
//  CourseDetailCell.m
//  Chenglong
//
//  Created by wangyaochang on 2017/1/4.
//  Copyright © 2017年 Chenglong. All rights reserved.
//

#import "CourseDetailCell.h"

@interface CourseDetailCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgCourse;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbUserName;
@property (weak, nonatomic) IBOutlet UILabel *lbContent;
@property (weak, nonatomic) IBOutlet UILabel *lbTime;
@property (weak, nonatomic) IBOutlet UIImageView *imgLove;
@property (weak, nonatomic) IBOutlet UILabel *lbLoveNum;

@end

@implementation CourseDetailCell

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
    CourseDetails *detail = self.data;
//    [_imgCourse sd_setImageWithURL:[NSURL URLWithString:detail.course] placeholderImage:[UIImage imageNamed:@"bb-512.png"]];
    
    
}
@end
