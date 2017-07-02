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
@property (nonatomic, strong) NSMutableArray *selectedArr;
@property (nonatomic, copy) BlankBlock lookOtherFileBlock;
@property(strong, nonatomic) NSString* currentDirId;


- (void)creatFolderEvent:(UIButton *)btn;
- (void)creatFileEvent:(UIButton *)btn;
- (void)resetFolderName;
- (void)reload;
@end
