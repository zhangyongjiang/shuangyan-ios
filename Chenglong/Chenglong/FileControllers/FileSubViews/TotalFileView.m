//
//  TotalFileView.m
//  Chenglong
//
//  Created by wangyaochang on 2016/12/30.
//  Copyright © 2016年 Chenglong. All rights reserved.
//

#import "TotalFileView.h"


@interface TotalFileView () <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) UIRefreshControl* refreshControl;
@property (nonatomic, strong) NSURLSessionDataTask* requestOperation;

@end

@implementation TotalFileView

- (void)awakeFromNib
{
    [super awakeFromNib];
    _totalFileTableView.tableFooterView = [UIView new];
    
}

- (void)setFileListArr:(NSMutableArray *)fileListArr
{
    _fileListArr = fileListArr;
    [_totalFileTableView reloadData];
}

#pragma mark - UITableView delegate datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _fileListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
