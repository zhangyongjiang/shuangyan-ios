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
    _totalFileTableView.tableHeaderView = headerView;
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [_totalFileTableView addSubview:self.refreshControl];
    
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
    self.requestOperation = [CourseApi CourseAPI_Search:_keywordsStr?:@"" page:@(_pageNum) onSuccess:^(CourseList *resp) {
        weakSelf.loading=NO;
        weakSelf.requestOperation = nil;
        [weakSelf insertFileList:resp];
        
        if ( isRefresh ) {
            [weakSelf.refreshControl endRefreshing];
        }
    } onError:^(APIError *err) {
        weakSelf.loading=NO;
        if (weakSelf.fileListArr.count<= 0) {
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

#pragma mark - UITableView delegate datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_fileListArr.count == 0) {
        
        RemindBlankView *bgView = [RemindBlankView loadWithImgTopValue:0 message:@"暂无文件" image:nil];
        bgView.isLoading = self.loading;
        self.totalFileTableView.backgroundView = bgView;
        return 0;
    }
    self.totalFileTableView.backgroundView = nil;
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
    for (CourseDetails *courseDetail in courseList.items) {
        [_fileListArr addObject:courseDetail];
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
