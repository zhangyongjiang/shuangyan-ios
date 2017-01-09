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
#import "CourseFolderCell.h"
#import "CourseDetailCell.h"

@interface MyFilesView () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) NSInteger pageNum;
@property(nonatomic, assign) BOOL loading;
@property (nonatomic, strong) UIRefreshControl* refreshControl;
@property (nonatomic, strong) NSURLSessionDataTask* requestOperation;

@end

@implementation MyFilesView

- (void)awakeFromNib
{
    [super awakeFromNib];
    _myFileTableView.tableFooterView = [UIView new];
    [_myFileTableView  registerNib:[UINib nibWithNibName:@"CourseDetailCell" bundle:nil] forCellReuseIdentifier:@"CourseDetailCell"];
    [_myFileTableView  registerNib:[UINib nibWithNibName:@"CourseFolderCell" bundle:nil] forCellReuseIdentifier:@"CourseFolderCell"];
    [_myFileTableView setSelfSeparatorInset:UIEdgeInsetsZero];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [_myFileTableView addSubview:self.refreshControl];
    
    [self reloadTotalFileList:NO];
}

- (void)resetFileDetailsList {
    
    _pageNum = 0;
}

#pragma mark - Refresh

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self resetFileDetailsList];
    [self reloadTotalFileList:YES];
}
#pragma mark - 获取数据
- (void)reloadTotalFileList:(BOOL)isRefresh {
    if ( self.requestOperation != nil ) {
        [self.requestOperation cancel];
        self.requestOperation = nil;
    }
    if ( isRefresh ) {
        [self.refreshControl beginRefreshing];
    }
    self.loading = YES;
    WeakSelf(weakSelf)
    self.requestOperation = [CourseApi CourseAPI_ListUserCourses:[Global loggedInUser].id page:@(_pageNum) onSuccess:^(CourseDetails *resp) {
        weakSelf.loading=NO;
        weakSelf.requestOperation = nil;
        [weakSelf insertFileList:resp.items];
        
        if ( isRefresh ) {
            [weakSelf.refreshControl endRefreshing];
        }
    } onError:^(APIError *err) {
        weakSelf.loading=NO;
        if (weakSelf.fileListArr.count<= 0) {
            [weakSelf.myFileTableView reloadData];
        }
        if ( isRefresh ) {
            [weakSelf.refreshControl endRefreshing];
        }
        if (_pageNum > 0) {
            _pageNum--;
        }
        if ( err.rawError.code != NSURLErrorCancelled ) {
            weakSelf.requestOperation = nil;
            ALERT_VIEW_WITH_TITLE(err.errorCode, err.errorMsg);
        }
    }];
}

#pragma mark - 空白页事件

- (void)gotoLookOtherFilesEvent:(UIButton *)btn
{
    if (self.lookOtherFileBlock) {
        self.lookOtherFileBlock();
    }
}
- (void)creatFileEvent:(UIButton *)btn
{
    
}
- (void)creatFolderEvent:(UIButton *)btn
{
    
}

#pragma mark - UITableView delegate datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_fileListArr.count == 0) {
        FileNoDataView *bgView = [FileNoDataView loadFromNib];
        [bgView.btnLookFiles addTarget:self action:@selector(gotoLookOtherFilesEvent:) forControlEvents:UIControlEventTouchUpInside];
        [bgView.btnFolder addTarget:self action:@selector(creatFolderEvent:) forControlEvents:UIControlEventTouchUpInside];
        [bgView.btnFile addTarget:self action:@selector(creatFileEvent:) forControlEvents:UIControlEventTouchUpInside];
        _myFileTableView.backgroundView = bgView;
        return 0;
    }
    _myFileTableView.backgroundView = nil;
    return _fileListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdenti = @"CourseFolderCell";
    Course *course = _fileListArr[indexPath.row];
    if (course.isDir.boolValue) {
        //文件夹
        cellIdenti = @"CourseFolderCell";
        CourseFolderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenti];
        return cell;
    }else{
        cellIdenti = @"CourseDetailCell";
        CourseDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseDetailCell"];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Course *course = _fileListArr[indexPath.row];
    return course.isDir.boolValue ? 44 : 100.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - handle data

- (void)insertFileList:(NSArray*)courseList {
    if (_pageNum == 0) {
        [self indexPathForCourseList:courseList];
        [_myFileTableView reloadData];
        
    }else{
        [_myFileTableView insertIndexPaths:[self indexPathForCourseList:courseList]];
    }
}

- (NSArray*)indexPathForCourseList:(NSArray*)courseList {
    
    if (_pageNum == 0) {
        [_fileListArr removeAllObjects];
    }
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    
    NSInteger index = (_fileListArr.count > 0) ? _fileListArr.count : 0;
    for (CourseDetails *courseDetail in courseList) {
        [_fileListArr addObject:courseDetail];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [indexPaths addObject:indexPath];
        index++;
    }
    return indexPaths;
}

@end
