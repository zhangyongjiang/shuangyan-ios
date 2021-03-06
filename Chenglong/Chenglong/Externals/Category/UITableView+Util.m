//
//  UITableView+Util.m
//  Chenglong
//
//  Created by wangyaochang on 2016/12/30.
//  Copyright © 2016年 Chenglong. All rights reserved.
//

#import "UITableView+Util.h"

@implementation UITableView (Util)


- (void)setSelfSeparatorInset:(UIEdgeInsets)separatorInset
{
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:separatorInset];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:separatorInset];
    }
}

- (void)reloadIndexPaths:(NSArray*)indexPaths {
    [self beginUpdates];
    [self reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self endUpdates];
}

- (void)insertIndexPaths:(NSArray*)indexPaths {
    [self beginUpdates];
    [self insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self endUpdates];
}

-(BOOL)isVisible:(NSIndexPath*)cellpath
{
    for (NSIndexPath* path in self.indexPathsForVisibleRows) {
        if(path.section == cellpath.section && path.row == cellpath.row)
            return YES;
    }
    return NO;
}

@end


