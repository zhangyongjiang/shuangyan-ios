//
//  UITableView+Util.m
//  Chenglong
//
//  Created by wangyaochang on 2016/12/30.
//  Copyright © 2016年 Chenglong. All rights reserved.
//

#import "UITableView+Util.h"

@implementation UITableView (Util)


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

@end
