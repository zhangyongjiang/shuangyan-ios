//
//  CreateFileViewController.m
//  Chenglong
//
//  Created by wangyaochang on 2017/1/10.
//  Copyright © 2017年 Chenglong. All rights reserved.
//

#import "CreateFileViewController.h"
#import "CreatFileViews.h"

static CGFloat creatFileViewHeight = 360.f;

@interface CreateFileViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) CreatFileViews *creatFileViews;
@end

@implementation CreateFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"新文件";
    self.view.backgroundColor = [UIColor kaishiColor:UIColorTypeBackgroundColor];
    
    [self configItem];
    [self configSubViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
    
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
    if ([NSString isEmpty:[self.creatFileViews.tvContent.text trim]] && self.creatFileViews.mediaAttachmentDataSource.attachments.count < 2) {
        [self presentFailureTips:@"内容和图片不能同时为空"];
        return;
    }
    Course *course = [Course new];
    course.title = [self.creatFileViews.tfTitle.text trim];
    course.content = [self.creatFileViews.tvContent.text trim];
    if (self.creatFileViews.mediaAttachmentDataSource.attachments.count < 2) {
        [SVProgressHUD showWithStatus:@"上传中"];
        [CourseApi CourseAPI_CreateCourseFile:course onSuccess:^(Course *resp) {
            
        } onError:^(APIError *err) {
            
        }];
    }else{
        
//        [CourseApi CourseAPI_CreateCourseFileWithResources:<#(NSDictionary *)#> json:<#(NSString *)#> onSuccess:<#^(Course *resp)successBlock#> onError:<#^(APIError *err)errorBlock#>
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
