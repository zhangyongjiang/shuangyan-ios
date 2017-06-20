//
//  ProfileHeaderCell.h
//  Chenglong
//
//  Created by wangyaochang on 2017/1/8.
//  Copyright © 2017年 Chenglong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgHeader;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbScoreNum;

@end
