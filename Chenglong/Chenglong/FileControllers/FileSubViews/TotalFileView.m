//
//  TotalFileView.m
//  Chenglong
//
//  Created by wangyaochang on 2016/12/30.
//  Copyright © 2016年 Chenglong. All rights reserved.
//

#import "TotalFileView.h"
#import "CourseDetailCell.h"
#import "TotalFileHeaderView.h"

@interface TotalFileView () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) NSInteger pageNum;
@property(nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) UIRefreshControl* refreshControl;
@property (nonatomic, strong) NSURLSessionDataTask* requestOperation;

@end

@implementation TotalFileView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorFromString:@"eeeeee"];
    _totalFileTableView.tableFooterView = [UIView new];
    _totalFileTableView.backgroundColor = [UIColor clearColor];
    [_totalFileTableView  registerNib:[UINib nibWithNibName:@"CourseDetailCell" bundle:nil] forCellReuseIdentifier:@"CourseDetailCell"];
    
    TotalFileHeaderView *headerView = [TotalFileHeaderView loadFromNibWithFrame:CGRectMake(0, 0, SCREEN_BOUNDS_SIZE_WIDTH, 60)];
    headerView.backgroundColor = [UIColor clearColor];
    _totalFileTableView.tableHeaderView = headerView;
}

- (void)setFileListArr:(NSMutableArray *)fileListArr
{
    _fileListArr = fileListArr;
    [_totalFileTableView reloadData];
}

#pragma mark - UITableView delegate datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 20;
    return _fileListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseDetailCell"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - handle data

- (void)insertFileList:(CourseList*)courseList {
    if (_pageNum == 0) {
        [self indexPathForCourseList:courseList];
        [_totalFileTableView reloadData];
        
    }else{
        [_totalFileTableView insertIndexPaths:[self indexPathForCourseList:courseList]];
    }
}

- (NSArray*)indexPathForCourseList:(CourseList*)courseList {
    
    if (_pageNum == 0) {
        [_fileListArr removeAllObjects];
    }
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    
    NSInteger index = (_fileListArr.count > 0) ? _fileListArr.count : 0;
    for (CourseDetails *courseDetail in _fileListArr) {
        [_fileListArr addObject:courseDetail];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [indexPaths addObject:indexPath];
        index++;
    }
    return indexPaths;
}

@end
