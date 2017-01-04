//
//  MyFilesView.m
//  Chenglong
//
//  Created by wangyaochang on 2016/12/29.
//  Copyright © 2016年 Chenglong. All rights reserved.
//

#import "MyFilesView.h"
#import "FileNoDataView.h"
#import "CourseDetailCell.h"

@interface MyFilesView () <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) UIRefreshControl* refreshControl;
@property (nonatomic, strong) NSURLSessionDataTask* requestOperation;

@end

@implementation MyFilesView

- (void)awakeFromNib
{
    [super awakeFromNib];
    _myFileTableView.tableFooterView = [UIView new];
    [_myFileTableView  registerNib:[UINib nibWithNibName:@"CourseDetailCell" bundle:nil] forCellReuseIdentifier:@"CourseDetailCell"];
    
}

- (void)setFileListArr:(NSMutableArray *)fileListArr
{
    _fileListArr = fileListArr;
    [_myFileTableView reloadData];
}

#pragma mark - UITableView delegate datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_fileListArr.count == 0) {
        FileNoDataView *bgView = [FileNoDataView loadFromNib];
        _myFileTableView.backgroundView = bgView;
        return 0;
    }
    _myFileTableView.backgroundView = nil;
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
