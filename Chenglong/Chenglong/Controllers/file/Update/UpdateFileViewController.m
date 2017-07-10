//
//  CreateFileViewController.m
//  Chenglong
//
//  Created by wangyaochang on 2017/1/10.
//  Copyright © 2017年 Chenglong. All rights reserved.
//

#import "UpdateFileViewController.h"
#import "CreatFileViews.h"

static CGFloat creatFileViewHeight = 420.f;

@interface UpdateFileViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) CreatFileViews *creatFileViews;
@end

@implementation UpdateFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"更改文件";
    self.view.backgroundColor = [UIColor kaishiColor:UIColorTypeBackgroundColor];
    
    [self configItem];
    [self configSubViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaDeleteButtonTapped:) name:@"JournalAttachmentDeleteButtonTapped" object:nil];
    
    self.creatFileViews.courseDetails = self.courseDetails;
}

- (void)mediaDeleteButtonTapped:(NSNotification *)noti
{
    MediaAttachment *attachment = noti.object;
    if(!attachment.url)
        return;
    Course* course = [Course new];
    course.id = self.courseDetails.course.id;
    __block MediaContent* mc = [MediaContent new];
    mc.url = attachment.url.absoluteString;
    course.resources = [NSMutableArray arrayWithObject:mc];
    WeakSelf(weakSelf)
    [CourseApi CourseAPI_RemoveResources:course onSuccess:^(Course *resp) {
        for (int i=0; i< weakSelf.courseDetails.course.resources.count; i++) {
            MediaContent* existing = [weakSelf.courseDetails.course.resources objectAtIndex:i];
            if([existing.url isEqualToString:mc.url]) {
                [weakSelf.courseDetails.course.resources removeObjectAtIndex:i];
                break;
            }
        }
        [self presentSuccessTips:@"Removed"];
    } onError:^(APIError *err) {
        [self presentFailureTips:@"Failed"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configItem
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismissCotrollerEvent:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submitFileEvent:)];
}

- (void)configSubViews
{
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_BOUNDS_SIZE_WIDTH, SCREEN_BOUNDS_SIZE_HEIGHT)];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(SCREEN_BOUNDS_SIZE_WIDTH, SCREEN_BOUNDS_SIZE_HEIGHT);
    
    _creatFileViews = [[CreatFileViews alloc] initWithFrame:CGRectMake(0, 0, SCREEN_BOUNDS_SIZE_WIDTH, creatFileViewHeight)];
    [self.scrollView addSubview:_creatFileViews];
    
    [self.view addSubview:self.scrollView];
    
}

//取消
- (void)dismissCotrollerEvent:(UIBarButtonItem *)item
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//提交文件
- (void)submitFileEvent:(UIBarButtonItem *)item
{
    if ([NSString isEmpty:[self.creatFileViews.tfTitle.text trim]]) {
        [self presentFailureTips:@"标题不能为空"];
        return;
    }
    
//    if ([NSString isEmpty:[self.creatFileViews.tfStartAge.text trim]]) {
//        [self presentFailureTips:@"开始年龄不能为空"];
//        return;
//    }
//    
//    if ([NSString isEmpty:[self.creatFileViews.tfEndAge.text trim]]) {
//        [self presentFailureTips:@"结束年龄不能为空"];
//        return;
//    }
//    
//    if ([self.creatFileViews.tfStartAge.text trim].integerValue > [self.creatFileViews.tfEndAge.text trim].integerValue) {
//        [self presentFailureTips:@"开始年龄不能大于结束年龄"];
//        return;
//    }
    
    if ([NSString isEmpty:[self.creatFileViews.tvContent.text trim]] && self.creatFileViews.mediaAttachmentDataSource.attachments.count < 2) {
        [self presentFailureTips:@"内容和图片不能同时为空"];
        return;
    }
    Course *course = [Course new];
    course.id = self.courseDetails.course.id;
    course.title = self.creatFileViews.tfTitle.text;
    course.content = self.creatFileViews.tvContent.text;
    WeakSelf(weakSelf)
    if (self.creatFileViews.mediaAttachmentDataSource.attachments.count < 2) {
        [SVProgressHUD showWithStatus:@"上传中"];
        [CourseApi CourseAPI_UpdateCourse:course onSuccess:^(Course *resp) {
            [SVProgressHUD dismiss];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationCourseChanged object:resp];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        } onError:^(APIError *err) {
            [SVProgressHUD dismiss];
            ALERT_VIEW_WITH_TITLE(err.errorCode, err.errorMsg);
        }];
    }else{
        [SVProgressHUD showWithStatus:@"上传中"];
        [CourseApi CourseAPI_UpdateCourseWithResources:@{@"file":self.creatFileViews.mediaAttachmentDataSource.attachments} json:[course toJson] onSuccess:^(Course *resp) {
            [SVProgressHUD dismiss];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationCourseChanged object:resp];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        } onError:^(APIError *err) {
            [SVProgressHUD dismiss];
            ALERT_VIEW_WITH_TITLE(err.errorCode, err.errorMsg);
        } progress:^(NSProgress *progress) {
            if ( weakSelf.creatFileViews.mediaAttachmentDataSource.attachments.count > 1 ) {
                [SVProgressHUD showUploadProgressWithStatus:@"上传中" progress:progress];
            }
        }];
    }
    
    
}

#pragma mark - 键盘
- (void)keyboardChange:(NSNotification *)note
{
    NSDictionary *keyboardInformation = note.userInfo;
    NSValue *keyboardFrameEnd = [keyboardInformation valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [keyboardFrameEnd CGRectValue];
    _scrollView.height = SCREEN_BOUNDS_SIZE_HEIGHT - keyboardFrame.size.height - 64;
    self.scrollView.contentSize = CGSizeMake(SCREEN_BOUNDS_SIZE_WIDTH, creatFileViewHeight);
    
}
- (void)keyboardHidden:(NSNotification *)note
{
    _scrollView.height = SCREEN_BOUNDS_SIZE_HEIGHT;
    self.scrollView.contentSize = CGSizeMake(SCREEN_BOUNDS_SIZE_WIDTH, SCREEN_BOUNDS_SIZE_HEIGHT);
}

@end
