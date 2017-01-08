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
    
    TotalFileHeaderView *headerView = [TotalFileHeaderView loadFromNibWithFrame:CGRectMake(0, 0, SCREEN_BOUNDS_SIZE_WIDTH, 60)];
    headerView.backgroundColor = [UIColor clearColor];
    _totalFileTableView.tableHeaderView = headerView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)setFileListArr:(NSMutableArray *)fileListArr
{
    _fileListArr = fileListArr;
    [_totalFileTableView reloadData];
}

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
//    self.requestOperation = [CourseApi CourseAPI_Search:<#(NSString *)#> page:<#(NSNumber *)#> onSuccess:<#^(CourseList *resp)successBlock#> onError:<#^(APIError *err)errorBlock#>];
//    self.requestOperation = [KaishiApi CommunityAPI_GetPostList:@((self.selectedPage.count-1)*numberOfPostsInPostList)
//                                                           size:@(numberOfPostsInPostList)
//                                                       latitude:nil
//                                                      longitude:nil
//                                                         radius:nil
//                                                        dueDate:[self.selectedCategory.name isEqualToString:KaishiLocalizedString(@"CommunityViewControllerLikeMe", nil)]?[Global loggedInUser].info.dueDate:nil
//                                                     categoryId:self.selectedCategory.categoryId
//                                                       keywords:self.selectedKeywords
//                                                      onSuccess:^(NSURLSessionDataTask *operation, PostDetailsList *resp) {
//                                                          weakSelf.loading=NO;
//                                                          weakSelf.requestOperation = nil;
//                                                          [weakSelf insertPostDetailList:resp];
//                                                          
//                                                          if ( isRefresh ) {
//                                                              [weakSelf.refreshControl endRefreshing];
//                                                          }
//                                                          if ( weakSelf.selectedKeywords.length > 0 ) {
//                                                              [Analytics trackEvent:@"communitySearch" params:@{@"keywords":weakSelf.selectedKeywords}];
//                                                          }
//                                                      } onError:^(APIError *err) {
//                                                          weakSelf.loading=NO;
//                                                          if (weakSelf.postDetailsList.items.count <= 0 && weakSelf.postDetailsList.hotAndEssenceItems.count <= 0) {
//                                                              [weakSelf.tableView reloadData];
//                                                          }
//                                                          if ( isRefresh ) {
//                                                              [weakSelf.refreshControl endRefreshing];
//                                                          }
//                                                          [weakSelf.selectedPage removeObject:@(weakSelf.selectedPage.count-1)];
//                                                          if ( err.rawError.code != NSURLErrorCancelled ) {
//                                                              weakSelf.requestOperation = nil;
//                                                              ALERT_VIEW_WITH_TITLE(err.errorCode, err.errorMsg);
//                                                          }
//                                                          
//                                                      } onRetry:^(NSURLSessionDataTask *oldOperation, NSURLSessionDataTask *newOperation) {
//                                                          weakSelf.requestOperation = newOperation;
//                                                      }];
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

#pragma mark - 键盘
- (void)keyboardChange:(NSNotification *)note
{
    NSDictionary *keyboardInformation = note.userInfo;
    NSValue *keyboardFrameEnd = [keyboardInformation valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [keyboardFrameEnd CGRectValue];
    [_totalFileTableView setContentInset:UIEdgeInsetsMake(0, 0, MAX(0, SCREEN_BOUNDS_SIZE_HEIGHT-keyboardFrame.origin.y-44), 0)];
    
}

@end
