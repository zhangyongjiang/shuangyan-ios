//
//  FileListViewController.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "FileListViewController.h"
#import "ObjectMapper.h"
#import "CreateFileViewController.h"

@interface FileListViewController ()<SelectIndexPathDelegate>

@property(strong, nonatomic) FileListPage* page;
@property (nonatomic, strong) UIBarButtonItem *rightMenuItem;

@end

@implementation FileListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
    [self createPage];

    if(self.courseId == NULL) {
        self.navigationItem.title = @"我的";
    }
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[[UIImage imageNamed:@"tab_btn_file_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tab_btn_file_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    self.tabBarItem.imageInsets = UIEdgeInsetsMake(-4, 0, 4, 0);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)createPage {
    self.page = [[FileListPage alloc] initWithFrame:self.view.bounds];
    self.page.filePath = self.filePath;
    [self.view addSubview:self.page];
    
    NSString* fileName = [self jsonFileName];
    NSFileManager* fm = [NSFileManager defaultManager];
    if([fm fileExistsAtPath:fileName]){
        NSData* data = [fm contentsAtPath:fileName];
        NSError *error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:&error];
        ObjectMapper* mapper = [ObjectMapper mapper];
        CourseDetailsList* resp = [mapper mapObject:json toClass:[CourseDetailsList class] withError:&error];
        if(error)
            [self refreshPage];
        else {
            self.navigationItem.title = resp.courseDetails.course.title;
            [self.page setCourseDetailsList:resp];
        }
    }
    else
        [self refreshPage];
}

-(void)refreshPage {
    [CourseApi CourseAPI_ListUserCourses:NULL currentDirId:self.courseId page:0 onSuccess:^(CourseDetailsList *resp) {
        if(resp.courseDetails) {
            self.navigationItem.title = resp.courseDetails.course.title;
        }
        [self.page setCourseDetailsList:resp];
        
        NSString* fileName = [self jsonFileName];
        NSString* json = [resp toJson];
        [json writeToFile:fileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
    } onError:^(APIError *err) {
        
    }];
}

-(NSString*)jsonFileName {
    NSString* fileName = [self.filePath stringByAppendingFormat:@"/%@.json", self.courseId];
    return fileName;
}

- (void)setupSubViews
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 40);
    [btn setImage:[UIImage imageNamed:@"nav_btn_more"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightItemEvent:) forControlEvents:UIControlEventTouchUpInside];
    _rightMenuItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = _rightMenuItem;
    
}

#pragma mark - 右侧item事件
- (void)rightItemEvent:(UIButton *)btn
{
    //    NSArray *arr = @[@"新文件",@"新文件夹",@"购买",@"移动",@"播放",@"改名"];
    //    NSArray *imgArr = @[@"file_item_newFile_icon",@"file_item_newfolder_icon",@"file_item_buy_icon",@"file_item_exchange_icon",@"file_item_play_icon",@"file_item_edit_icon"];
    NSArray *arr = @[@"新文件",@"新文件夹",@"移动",@"播放",@"改名"];
    NSArray *imgArr = @[@"file_item_newFile_icon",@"file_item_newfolder_icon",@"file_item_exchange_icon",@"file_item_play_icon",@"file_item_edit_icon"];
    CGPoint point = CGPointMake(btn.frame.origin.x + btn.frame.size.width / 2, btn.frame.origin.y + btn.frame.size.height + 10);
    XTPopTableView *_menuTableView = [[XTPopTableView alloc] initWithOrigin:point Width:150 Height:45*arr.count Type:XTTypeOfUpRight Color:[UIColor whiteColor]];
    _menuTableView.backgroundColor = [UIColor colorWithWhite:0 alpha:.3f];
    [_menuTableView.tableView setSeparatorColor:[UIColor colorFromString:@"dedede"]];
    _menuTableView.dataArray = arr;
    _menuTableView.images = imgArr;
    _menuTableView.row_height = 45;
    _menuTableView.delegate = self;
    _menuTableView.fontSize = 14.f;
    _menuTableView.textAlignment = NSTextAlignmentLeft;
    _menuTableView.titleTextColor = [UIColor colorFromString:@"1a1a1a"];
    _menuTableView.tag = 10001;
    [_menuTableView popView];
}

#pragma mark - menuView delegate
- (void)selectIndexPathRow:(NSInteger )index view:(XTPopViewBase *)baseView
{
        if (index == 0) {
            CreateFileViewController *file = [CreateFileViewController loadFromNib];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:file];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }
        else if(index == 1){
            //新建文件夹
            [self creatFolderEvent:nil];
        }
        else if (index == 4){
            //改名
            [self resetFolderName];
        }
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
        course.parentCourseId = self.courseId;
        [SVProgressHUD showWithStatus:@"创建中"];
        [CourseApi CourseAPI_CreateCourseDir:course onSuccess:^(Course *resp) {
            
            [SVProgressHUD dismiss];
            
            [weakSelf refreshPage];
            
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
    CourseDetails* selected = [self.page selected];
    if(!selected) {
        [self presentFailureTips:@"请选择一个文件或者文件夹"];
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
        RenameRequest *request = [RenameRequest new];
        request.courseId = selected.course.id;
        request.name = tf.text;
        [SVProgressHUD showWithStatus:@"修改中"];
        [CourseApi CourseAPI_RenameCourse:request onSuccess:^(Course *resp) {
            [SVProgressHUD dismiss];
            [self refreshPage];
        } onError:^(APIError *err) {
            [SVProgressHUD dismiss];
            ALERT_VIEW_WITH_TITLE(err.errorCode, err.errorMsg);
        }];
    }];
    [alert addAction:actionSure];
    [[self getCurrentNavController] presentViewController:alert animated:YES completion:^{
        
    }];
}
@end
