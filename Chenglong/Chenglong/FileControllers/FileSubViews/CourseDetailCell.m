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
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation CourseDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _dateFormatter = [[NSDateFormatter alloc] init];
    _dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dataDidChange
{
    CourseDetails *detail = self.data;
//    [_imgCourse sd_setImageWithURL:[NSURL URLWithString:detail.course] placeholderImage:[UIImage imageNamed:@"bb-512.png"]];
    _lbName.text = detail.course.title;
    _lbContent.text = detail.course.content;
    _lbTime.text = [_dateFormatter stringFromDate:[NSDate dateFromMillisecs:detail.course.created]];
    _lbLoveNum.text = detail.liked.stringValue;
}
@end
