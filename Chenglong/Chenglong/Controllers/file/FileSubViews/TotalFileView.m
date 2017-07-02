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

@property (nonatomic, strong) TotalFileHeaderView *fileHeaderView;

@property (nonatomic, strong) NSString *keywordsStr;
@property (nonatomic, strong) NSString *ageStr;
@property (nonatomic, assign) NSInteger pageNum;
@property(nonatomic, assign) BOOL loading;
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
    [_totalFileTableView setSelfSeparatorInset:UIEdgeInsetsZero];
    
    TotalFileHeaderView *headerView = [TotalFileHeaderView loadFromNibWithFrame:CGRectMake(0, 0, SCREEN_BOUNDS_SIZE_WIDTH, 60)];
    headerView.backgroundColor = [UIColor clearColor];
    _fileHeaderView = headerView;
    [headerView.btnSearch addTarget:self action:@selector(btnSearchEvent:) forControlEvents:UIControlEventTouchUpInside];
    _totalFileTableView.tableHeaderView = headerView;
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [_totalFileTableView addSubview:self.refreshControl];
    
    _courseList = [CourseDetailsList new];
    _courseList.items = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
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
    self.requestOperation = [CourseApi CourseAPI_Search:_keywordsStr age:_ageStr.integerValue > 0 ? @(_ageStr.integerValue) : nil page:@(_pageNum) onSuccess:^(CourseDetailsList *resp) {
        weakSelf.loading=NO;
        weakSelf.requestOperation = nil;
        [weakSelf insertFileList:resp];
        
        if ( isRefresh ) {
            [weakSelf.refreshControl endRefreshing];
        }
    } onError:^(APIError *err) {
        weakSelf.loading=NO;
        if (weakSelf.courseList.items.count<= 0) {
            [weakSelf.totalFileTableView reloadData];
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

#pragma mark - 搜索
- (void)btnSearchEvent:(UIButton *)btn
{
    _keywordsStr = _fileHeaderView.tfKeyword.text;
    _ageStr = _fileHeaderView.tfAge.text;
    if (![NSString isEmpty:_ageStr] || ![NSString isEmpty:_keywordsStr]) {
        [self endEditing:YES];
        [self resetFileDetailsList];
        [self reloadTotalFileList:NO];
    }
}

#pragma mark - UITableView delegate datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_courseList.items.count == 0) {
        
        RemindBlankView *bgView = [RemindBlankView loadWithImgTopValue:0 message:@"暂无文件" image:nil];
        bgView.isLoading = self.loading;
        self.totalFileTableView.backgroundView = bgView;
        return 0;
    }
    self.totalFileTableView.backgroundView = nil;
    return _courseList.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseDetailCell"];
    cell.data = _courseList.items[indexPath.row];
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

- (void)insertFileList:(CourseDetailsList*)courseList {
    if (_pageNum == 0) {
        [self indexPathForCourseList:courseList];
        [_totalFileTableView reloadData];
        
    }else{
        [_totalFileTableView insertIndexPaths:[self indexPathForCourseList:courseList]];
    }
}

- (NSArray*)indexPathForCourseList:(CourseDetailsList*)courseList {
    
    if (_pageNum == 0) {
        [_courseList.items removeAllObjects];
    }
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    
    NSInteger index = (_courseList.items.count > 0) ? _courseList.items.count : 0;
    for (CourseDetails *courseDetail in courseList.items) {
        [_courseList.items addObject:courseDetail];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [indexPaths addObject:indexPath];
        index++;
    }
    return indexPaths;
}

#pragma mark - 键盘
- (void)keyboardChange:(NSNotification *)note
{
    NSDictionary *keyboardInformation = note.userInfo;
    NSValue *keyboardFrameEnd = [keyboardInformation valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [keyboardFrameEnd CGRectValue];
    [_totalFileTableView setContentInset:UIEdgeInsetsMake(0, 0, MAX(0, SCREEN_BOUNDS_SIZE_HEIGHT-keyboardFrame.origin.y-44), 0)];
    
}

@end
