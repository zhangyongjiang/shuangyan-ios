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
#import "CreateFileViewController.h"

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
    
    _fileListArr = [NSMutableArray array];
    _selectedArr = [NSMutableArray array];
    
    [self reloadTotalFileList:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(publishFileSuccessEvent:) name:kPublishFileSuccessNotificationKey object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_requestOperation) {
        [_requestOperation cancel];
        _requestOperation = nil;
    }
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
    self.requestOperation = [CourseApi CourseAPI_ListUserCourses:[Global loggedInUser].id page:@(_pageNum) onSuccess:^(CourseDetailsList *resp) {
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
    CreateFileViewController *file = [CreateFileViewController loadFromNib];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:file];
    [[self getCurrentNavController] presentViewController:nav animated:YES completion:nil];
}
- (void)creatFolderEvent:(UIButton *)btn
{
    WeakSelf(weakSelf)
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"文件名称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:actionCancel];
    UIAlertAction *actionSure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *tf = [alert.textFields firstObject];
        if ([NSString isEmpty:tf.text]) {
            [self presentFailureTips:@"文件标题不能为空"];
            return;
        }
        Course *course = [Course new];
        course.title = tf.text;
        [SVProgressHUD showWithStatus:@"创建中"];
        [CourseApi CourseAPI_CreateCourseDir:course onSuccess:^(Course *resp) {
            
            [SVProgressHUD dismiss];
            
            [weakSelf.fileListArr addObject:resp];
            
            if (weakSelf.fileListArr.count > 1) {
                [weakSelf.myFileTableView insertIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]];
            }else{
                [weakSelf.myFileTableView reloadData];
            }
            
        } onError:^(APIError *err) {
            
            [SVProgressHUD dismiss];
            ALERT_VIEW_WITH_TITLE(err.errorCode, err.errorMsg);
        }];
    }];
    [alert addAction:actionSure];
    [[self getCurrentNavController] presentViewController:alert animated:YES completion:^{
        
    }];
}

- (void)resetFolderName
{
    if (_selectedArr.count == 0) {
        [self presentFailureTips:@"请选择一个文件"];
        return;
    }else if (_selectedArr.count > 1) {
        [self presentFailureTips:@"不能选择多个文件"];
        return;
    }
    
    WeakSelf(weakSelf)
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改文件名称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:actionCancel];
    UIAlertAction *actionSure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *tf = [alert.textFields firstObject];
        if ([NSString isEmpty:tf.text]) {
            [self presentFailureTips:@"文件标题不能为空"];
            return;
        }
        CourseDetails *details = weakSelf.selectedArr[0];
        RenameRequest *request = [RenameRequest new];
        request.courseId = details.course.id;
        request.name = tf.text;
        [SVProgressHUD showWithStatus:@"修改中"];
        [CourseApi CourseAPI_RenameCourse:request onSuccess:^(Course *resp) {
            [SVProgressHUD dismiss];
            
            [weakSelf.selectedArr removeObject:details];
            NSInteger index = [weakSelf.fileListArr indexOfObject:details];
            details.course = resp;
            [weakSelf.myFileTableView reloadIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
            
        } onError:^(APIError *err) {
            [SVProgressHUD dismiss];
            ALERT_VIEW_WITH_TITLE(err.errorCode, err.errorMsg);
        }];
    }];
    [alert addAction:actionSure];
    [[self getCurrentNavController] presentViewController:alert animated:YES completion:^{
        
    }];
}

- (void)publishFileSuccessEvent:(NSNotification *)noti
{
    [self resetFileDetailsList];
    [self reloadTotalFileList:NO];
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
    CourseDetails *courseDetail = _fileListArr[indexPath.row];
    CourseFolderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenti];
    cell.courseDetails = courseDetail;
    cell.btnFileSected.selected = [_selectedArr containsObject:courseDetail];
    WeakSelf(weakSelf)
    cell.btnSelectedBlock = ^{
        //选择
        if ([weakSelf.selectedArr containsObject:courseDetail]) {
            //已经包含
            [weakSelf.selectedArr removeObject:courseDetail];
        }else{
            [weakSelf.selectedArr addObject:courseDetail];
        }
    };
    return cell;
//    if (course.isDir.boolValue) {
//        //文件夹
//        cellIdenti = @"CourseFolderCell";
//        CourseFolderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenti];
//        cell.data = course;
//        return cell;
//    }else{
//        cellIdenti = @"CourseDetailCell";
//        CourseDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseDetailCell"];
//        CourseDetails *detail = [CourseDetails new];
//        detail.course = course;
//        cell.data = detail;
//        return cell;
//    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CourseDetails *courseDetail = _fileListArr[indexPath.row];
        WeakSelf(weakSelf)
        [CourseApi CourseAPI_RemoveCourse:courseDetail.course.id onSuccess:^(Course *resp) {
            
            [weakSelf.fileListArr removeObjectAtIndex:indexPath.row];
            
            if (weakSelf.fileListArr.count <= 0) {
                [tableView reloadData];
            }else{
                [tableView beginUpdates];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [tableView endUpdates];
            }
            
        } onError:^(APIError *err) {
            
        }];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
//    CourseDetails *detail = _fileListArr[indexPath.row];
//    return detail.course.isDir.boolValue ? 44 : 100.f;
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
