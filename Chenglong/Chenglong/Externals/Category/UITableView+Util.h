//
//  UITableView+Util.h
//  Chenglong
//
//  Created by wangyaochang on 2016/12/30.
//  Copyright © 2016年 Chenglong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Util)
- (void)setSelfSeparatorInset:(UIEdgeInsets)separatorInset;
- (void)reloadIndexPaths:(NSArray*)indexPaths;
- (void)insertIndexPaths:(NSArray*)indexPaths;
-(BOOL)isVisible:(NSIndexPath*)cellpath;
@end


