//
//  BaseViewController.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController () <SelectIndexPathDelegate>

@property (nonatomic, strong) UIBarButtonItem *rightMenuItem;
@property (nonatomic, strong) NSArray* menuItems;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;
    // Do any additional setup after loading the view.
}

- (void)addTopRightMenu:(NSArray*)menuItems
{
    self.menuItems = menuItems;
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
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    NSMutableArray* imgArr = [[NSMutableArray alloc] init];
    for (MenuItem* mi in self.menuItems) {
        [arr addObject:mi.text];
        [imgArr addObject:mi.imgName];
    }

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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationPushController:) name:NotificationPushController object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRefreshControl:) name:NotificationRefreshControl object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationEndOfDisplay:) name:NotificationEndOfDisplay object:nil];
}

-(void)notificationEndOfDisplay:(NSNotification*)noti {
    UIView* subview = noti.object;
    if([subview isSameViewOrChildOf:self.view]) {
        [self nextPage];
    }
}

-(void)nextPage {
}

-(BOOL)hasNextPage:(int)pageSize current:(int)currentPage currentItems:(NSInteger)currentItems {
    if (currentItems%PageSize != 0 || currentPage*pageSize==currentItems) {
        return NO;
    }
    return YES;
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)notificationRefreshControl:(NSNotification*)noti {
    [self refreshPage];
}

-(void) refreshPage {
}

-(void)notificationPushController:(NSNotification*)noti {
    if (self.isViewLoaded && self.view.window) {
        UIView* subview = noti.object;
        if([subview isSameViewOrChildOf:self.view]) {
            UIViewController* controller = [noti.userInfo objectForKey:@"controller"];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

#pragma mark - menuView delegate
- (void)selectIndexPathRow:(NSInteger )index view:(XTPopViewBase *)baseView
{
    MenuItem* mi = [self.menuItems objectAtIndex:index];
    [self topRightMenuItemClicked:mi.text];
}

-(void)topRightMenuItemClicked:(NSString*)cmd {
}


@end
