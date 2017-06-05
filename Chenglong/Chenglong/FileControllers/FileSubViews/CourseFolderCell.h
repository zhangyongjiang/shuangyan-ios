//
//  CourseFolderCell.h
//  Chenglong
//
//  Created by wangyaochang on 2017/1/8.
//  Copyright © 2017年 Chenglong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseFolderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *btnFileSected;
@property (nonatomic, copy) BlankBlock btnSelectedBlock;
@property (strong, atomic) CourseDetails* courseDetails;
@end
