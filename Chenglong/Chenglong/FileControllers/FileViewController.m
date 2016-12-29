//
//  FileViewController.m
//  Chenglong
//
//  Created by wangyaochang on 2016/12/26.
//  Copyright © 2016年 Chenglong. All rights reserved.
//

#import "FileViewController.h"
#import "FilesChooseTitleView.h"

@interface FileViewController ()<SelectIndexPathDelegate>

@property (nonatomic, strong) FilesChooseTitleView *fileTitleView;
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
    
    [self setupSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupSubViews
{
    WeakSelf(weakSelf)
    _fileTitleView = [FilesChooseTitleView loadFromNibWithFrame:CGRectMake(0, 0, 200, 43)];
    _fileTitleView.tapTitleBlock = ^{
        [weakSelf.fileTitleView setupImgIconDirection:YES];
        [weakSelf showMenuTableView];
    };
    self.navigationItem.titleView = _fileTitleView;
}

#pragma mark - menuView delegate
- (void)selectIndexPathRow:(NSInteger )index
{
    [_fileTitleView setupImgIconDirection:NO];
    
}

#pragma mark - setter getter
- (void)showMenuTableView
{
    CGPoint point = CGPointMake(_fileTitleView.center.x, _fileTitleView.center.y + _fileTitleView.height/2 + 10);
    XTPopTableView *_menuTableView = [[XTPopTableView alloc] initWithOrigin:point Width:150 Height:45*2 Type:XTTypeOfUpCenter Color:[UIColor kaishiColor:UIColorTypeThemeSelected]];
    _menuTableView.dataArray       = @[@"我的文件", @"全部文件"];
    _menuTableView.images          = @[@"我的文件", @"全部文件"];
    _menuTableView.row_height      = 45;
    _menuTableView.delegate        = self;
    _menuTableView.fontSize = 15.f;
    _menuTableView.textAlignment = NSTextAlignmentCenter;
    _menuTableView.titleTextColor  = [UIColor whiteColor];
    _menuTableView.dismissBlock = ^{
        [_fileTitleView setupImgIconDirection:NO];
    };
    [_menuTableView popView];
    
}
@end
