//
//  TotalFileView.h
//  Chenglong
//
//  Created by wangyaochang on 2016/12/30.
//  Copyright © 2016年 Chenglong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TotalFileView : UIView

@property (weak, nonatomic) IBOutlet UITableView *totalFileTableView;
@property (nonatomic, strong) NSMutableArray *fileListArr;
@end
