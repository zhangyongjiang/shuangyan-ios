//
//  BaseViewController.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "BaseViewController.h"
#import "Page.h"

@interface BaseViewController () <SelectIndexPathDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>


@property (nonatomic, strong) UIBarButtonItem *rightMenuItem;
@property (nonatomic, strong) UIButton* btn;
@property (nonatomic, assign) int lockScreen;

@property (nonatomic, strong) UIView* lockView;

@end

@implementation BaseViewController

-(void)setup
{
    self.lockScreen = 0;
    
    self.view.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    self.lockView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIView screenWidth], [UIView screenHeight])];
    self.lockView.hidden = YES;
    self.lockView.userInteractionEnabled = YES;
    self.lockView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.lockView];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addTopRightMenu
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 40);
    [btn setImage:[UIImage imageNamed:@"nav_btn_more"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightItemEvent:) forControlEvents:UIControlEventTouchUpInside];
    _rightMenuItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = _rightMenuItem;
    self.btn = btn;
}

#pragma mark - 右侧item事件
- (void)rightItemEvent:(UIButton *)button
{
    [self popMenu];
}

-(void)popMenu
{
    UIButton* btn = self.btn;
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    NSMutableArray* imgArr = [[NSMutableArray alloc] init];
    NSMutableArray* enabled = [[NSMutableArray alloc] init];
    NSMutableArray* menuItems = [self getTopRightMenuItems];
    for (MenuItem* mi in menuItems) {
        [arr addObject:mi.text];
        [imgArr addObject:mi.imgName];
        [enabled addObject:mi.enabled];
    }

//    CGPoint point = CGPointMake(btn.frame.origin.x + btn.frame.size.width / 2, btn.frame.origin.y + btn.frame.size.height + 10);
    CGPoint point = CGPointMake(UIView.screenWidth-25, btn.frame.origin.y + btn.frame.size.height + 10);
    XTPopTableView *_menuTableView = [[XTPopTableView alloc] initWithOrigin:point Width:150 Height:45*arr.count Type:XTTypeOfUpRight Color:[UIColor whiteColor]];
    _menuTableView.backgroundColor = [UIColor colorWithWhite:0 alpha:.3f];
    [_menuTableView.tableView setSeparatorColor:[UIColor colorFromString:@"dedede"]];
    _menuTableView.dataArray = arr;
    _menuTableView.images = imgArr;
    _menuTableView.enabled = enabled;
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

-(void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationPushController:) name:NotificationPushController object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationPresentController:) name:NotificationPresentController object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRefreshControl:) name:NotificationRefreshControl object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationEndOfDisplay:) name:NotificationEndOfDisplay object:nil];
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeBottom;
}

-(void)notificationPresentController:(NSNotification*)noti {
    UIView* subview = noti.object;
    if([subview isSameViewOrChildOf:self.view]) {
        UIViewController* controller = [noti.userInfo objectForKey:@"controller"];
        [self.navigationController presentViewController:controller animated:YES completion:^{
        }];
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view bringSubviewToFront:_navBgView];
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
    NSMutableArray* menuItems = [self getTopRightMenuItems];
    MenuItem* mi = [menuItems objectAtIndex:index];
    [self topRightMenuItemClicked:mi.text];
}

-(void)topRightMenuItemClicked:(NSString*)cmd {
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

-(UIBarButtonItem*)addNavRightButton:(NSString *)text target:(id)target action:(SEL)action {
    UIBarButtonItem* btn = [[UIBarButtonItem alloc] initWithTitle:text style:UIBarButtonItemStylePlain target:target action:action];
    if (false) {
        self.navigationItem.rightBarButtonItem = btn;
        
        self.navigationItem.rightBarButtonItem.target = target;
        self.navigationItem.rightBarButtonItem.action = action;
        
        UIColor* color = [UIColor mainColor];
//        if (self.transparentNavbar) {
//            color = [UIColor whiteColor];
//        }
        NSDictionary *barButtonAppearanceDict = @{NSFontAttributeName : [UIFont fontWithName:@"GothamRounded-Light" size:15.0], NSForegroundColorAttributeName:color};
        [btn setTitleTextAttributes:barButtonAppearanceDict forState:UIControlStateNormal];
        NSDictionary* textAttributes = [NSDictionary dictionaryWithObject: color
                                                                   forKey: NSForegroundColorAttributeName];
        [btn setTitleTextAttributes:textAttributes forState:UIControlStateDisabled];
        
        return btn;
    }
    else {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0,0,80,24);
        button.titleLabel.font = [UIFont fontWithName:@"GothamRounded-Light" size:15.0];
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:text forState: UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [button setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];
//        if (self.transparentNavbar) {
//            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        }
        UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = customBarItem;
        return customBarItem;
    }
}

-(UIBarButtonItem*)addNavRightImgButton:(UIImage *)img target:(id)target action:(SEL)action {
    UIBarButtonItem* btn = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:target action:action];
    self.navigationItem.rightBarButtonItem = btn;
    return btn;
}

-(UIBarButtonItem*)addNavRightIconButton:(UIBarButtonSystemItem)sysItem target:(id)target action:(SEL)action {
    UIBarButtonItem* btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:sysItem target:target action:action];
    self.navigationItem.rightBarButtonItem = btn;
    return btn;
}

-(void)removeNavRightButton {
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 38, 38)];
    [rightButton setImage:nil forState:UIControlStateNormal];
    UIBarButtonItem* btn = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = btn;
}

-(BOOL)isSameViewController:(UIViewController*)c
{
    if(self == c)
        return YES;
    return NO;
}

-(NSMutableArray*)getTopRightMenuItems
{
    return NULL;
}

- (BOOL)shouldAutorotate {
    return self.lockScreen == 0;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (UIEventSubtypeMotionShake) {
        if(self.lockScreen == 0) {
            toast(@"屏幕锁定");
            self.lockView.hidden = NO;
            self.lockView.backgroundColor = [UIColor clearColor];
            [self.view bringSubviewToFront:self.lockView];
        }
        else if(self.lockScreen == 1) {
            self.lockView.backgroundColor = [UIColor blackColor];
            self.lockView.hidden = NO;
            [self.view bringSubviewToFront:self.lockView];
        }
        else if(self.lockScreen == 2) {
            toast(@"屏幕解除锁定");
            self.lockView.hidden = YES;
            [self.view bringSubviewToFront:self.lockView];
        }
        self.lockScreen = (self.lockScreen+1)%3;
    }
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.lockView.frame = CGRectMake(0, 0, [UIView screenWidth], [UIView screenHeight]);
}

@end
