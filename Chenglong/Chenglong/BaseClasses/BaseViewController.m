//
//  BaseViewController.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController () <SelectIndexPathDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>


@property (nonatomic, strong) UIBarButtonItem *rightMenuItem;
@property (nonatomic, strong) NSArray* menuItems;

@end

@implementation BaseViewController

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
    [self.view bringSubviewToFront:_navBgView];
    
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


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //作为导航栏的背景
    _navBgView = [UIView newAutoLayoutView];
    _navBgView.backgroundColor = [UIColor kaishiColor:UIColorTypeBarBackground];
    [self.view addSubview:_navBgView];
    _shadowLineView = [UIView newAutoLayoutView];
    _shadowLineView.backgroundColor = [UIColor kaishiColor:UIColorTypeTableSeparateColor];
    [_navBgView addSubview:_shadowLineView];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    [_navBgView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(-64, 0, 0, 0) excludingEdge:ALEdgeBottom];
    [_navBgView autoSetDimension:ALDimensionHeight toSize:64.f];
    [_shadowLineView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [_shadowLineView autoSetDimension:ALDimensionHeight toSize:1.f];
}


//显示错误信息等
- (void)alertShowWithMsg:(NSString *)msg
{
    if(iOSVersionGreaterThanOrEqualTo(@"8.0")){
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
        [alertCon addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alertCon animated:YES completion:^{}];}
    else{
        ALERT_VIEW(msg);
    }
}

-(void)loadCameraOrPhotoLibraryWithDelegate:(id)delegate allowEditing:(BOOL)allowEditing {
    if ([UIAlertController class])
    {
        UIAlertController* alertCtrl = [UIAlertController alertControllerWithTitle:nil
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleActionSheet];
        //Create an action
        UIAlertAction *camera = [UIAlertAction actionWithTitle:@"Camera"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action)
                                 {
                                     UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
                                     imagePicker.delegate = delegate;
                                     imagePicker.allowsEditing = allowEditing;
                                     imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                     [self presentViewController:imagePicker animated:YES completion:nil];
                                 }];
        UIAlertAction *imageGallery = [UIAlertAction actionWithTitle:@"Image Gallery"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action)
                                       {
                                           UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
                                           imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                           imagePicker.delegate = delegate;
                                           imagePicker.allowsEditing = allowEditing;
                                           [self presentViewController:imagePicker animated:YES completion:nil];
                                       }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction *action)
                                 {
                                     [self dismissViewControllerAnimated:YES completion:nil];
                                 }];
        
        
        //Add action to alertCtrl
        [alertCtrl addAction:camera];
        [alertCtrl addAction:imageGallery];
        [alertCtrl addAction:cancel];
        [self presentViewController:alertCtrl animated:YES completion:^{
        }];
    }
    
}

@end
