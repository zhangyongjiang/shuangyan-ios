//
//  MyFilesView.h
//  Chenglong
//
//  Created by wangyaochang on 2016/12/29.
//  Copyright © 2016年 Chenglong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyFilesView : UIView

@property (weak, nonatomic) IBOutlet UITableView *myFileTableView;
@property (nonatomic, strong) NSMutableArray *fileListArr;
@property (nonatomic, copy) BlankBlock lookOtherFileBlock;

- (void)creatFolderEvent:(UIButton *)btn;
- (void)creatFileEvent:(UIButton *)btn;
@end
