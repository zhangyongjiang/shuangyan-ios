//
//  FileViewController.m
//  Chenglong
//
//  Created by wangyaochang on 2016/12/26.
//  Copyright © 2016年 Chenglong. All rights reserved.
//

#import "FileViewController.h"
#import "FilesChooseTitleView.h"
#import "MyFilesView.h"
#import "TotalFileView.h"
#import "CreateFileViewController.h"

@interface FileViewController ()<SelectIndexPathDelegate>

@property (nonatomic, strong) FilesChooseTitleView *fileTitleView;
@property (nonatomic, strong) MyFilesView *myFileView;
@property (nonatomic, strong) TotalFileView *totalFileView;
@property (nonatomic, strong) UIBarButtonItem *rightMenuItem;
@property (nonatomic, strong) NSArray *titleChooseArr;
@end

@implementation FileViewController

#pragma mark - init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"文件" image:[[UIImage imageNamed:@"tab_btn_file_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tab_btn_file_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    self.tabBarItem.imageInsets = UIEdgeInsetsMake(-4, 0, 4, 0);
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"文件";
    
    _titleChooseArr = @[@"我的文件", @"全部文件"];
    
    [self setupSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupSubViews
{
    WeakSelf(weakSelf)
    _fileTitleView = [FilesChooseTitleView loadFromNibWithFrame:CGRectMake(0, 0, 200, 42)];
    _fileTitleView.tapTitleBlock = ^{
        [weakSelf.view endEditing:YES];
        [weakSelf.fileTitleView setupImgIconDirection:YES];
        [weakSelf showMenuTableView];
    };
    self.navigationItem.titleView = _fileTitleView;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 40);
    [btn setImage:[UIImage imageNamed:@"nav_btn_more"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightItemEvent:) forControlEvents:UIControlEventTouchUpInside];
    _rightMenuItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = _rightMenuItem;
    
    //初始化 我的文件 and 全部文件 view
    _totalFileView = [TotalFileView loadFromNib];
    [self.view addSubview:_totalFileView];
    
    _myFileView = [MyFilesView loadFromNib];
    _myFileView.lookOtherFileBlock = ^{
        [weakSelf handleTitleView:1];
    };
    [self.view addSubview:_myFileView];
    
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    [_myFileView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    [_totalFileView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
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
    _menuTableView.dismissBlock = ^{
        [_fileTitleView setupImgIconDirection:NO];
    };
    [_menuTableView popView];
}

#pragma mark - 显示中间选择菜单
- (void)showMenuTableView
{
    CGPoint point = CGPointMake(_fileTitleView.center.x, _fileTitleView.center.y + _fileTitleView.height/2 + 10);
    XTPopTableView *_menuTableView = [[XTPopTableView alloc] initWithOrigin:point Width:150 Height:45*_titleChooseArr.count Type:XTTypeOfUpCenter Color:[UIColor kaishiColor:UIColorTypeThemeSelected]];
    _menuTableView.dataArray = _titleChooseArr;
    _menuTableView.row_height = 45;
    _menuTableView.delegate = self;
    _menuTableView.fontSize = 15.f;
    _menuTableView.textAlignment = NSTextAlignmentCenter;
    _menuTableView.titleTextColor = [UIColor whiteColor];
    _menuTableView.tag = 10000;
    _menuTableView.dismissBlock = ^{
        [_fileTitleView setupImgIconDirection:NO];
    };
    [_menuTableView popView];
    
}

//处理中间title
- (void)handleTitleView:(NSInteger)index
{
    [_fileTitleView setupImgIconDirection:NO];
    [_fileTitleView setupTitle:_titleChooseArr[index]];
    
    if (index == 0) {
        [self.view bringSubviewToFront:_myFileView];
        self.navigationItem.rightBarButtonItem = _rightMenuItem;
    }else if (index == 1){
        [self.view bringSubviewToFront:_totalFileView];
        self.navigationItem.rightBarButtonItem = nil;
    }
}

#pragma mark - menuView delegate
- (void)selectIndexPathRow:(NSInteger )index view:(XTPopViewBase *)baseView
{
    if (baseView.tag == 10000) {
        [self handleTitleView:index];
    }else{
        if (index == 0) {
            CreateFileViewController *file = [CreateFileViewController loadFromNib];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:file];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }else if(index == 1){
            //新建文件夹
            [self.myFileView creatFolderEvent:nil];
        }else if (index == 4){
            //改名
            [self.myFileView resetFolderName];
        }
    }
}

@end
