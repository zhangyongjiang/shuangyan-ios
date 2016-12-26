//
//  ZaoJiaoBgViewController.m
//  Chenglong
//
//  Created by wangyaochang on 2016/12/26.
//  Copyright © 2016年 Chenglong. All rights reserved.
//

#import "ZaoJiaoBgViewController.h"

@interface ZaoJiaoBgViewController ()

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view bringSubviewToFront:_navBgView];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
    [_shadowLineView autoSetDimension:ALDimensionHeight toSize:.5f];
}


@end
