//
//  ZaoJiaoBgViewController.m
//  Chenglong
//
//  Created by wangyaochang on 2016/12/26.
//  Copyright © 2016年 Chenglong. All rights reserved.
//

#import "ZaoJiaoBgViewController.h"
#import "UIView+Position.h"

@interface ZaoJiaoBgViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation ZaoJiaoBgViewController

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view bringSubviewToFront:_navBgView];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationPushController:) name:NotificationPushController object:nil];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
