//
//  SpendingHistoryViewController.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/27/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "SpendingHistoryViewController.h"
#import "SpendingHistoryPage.h"
#import "MoneyAPI.h"

@interface SpendingHistoryViewController ()

@property(strong,nonatomic)SpendingHistoryPage* page;

@end

@implementation SpendingHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = [[SpendingHistoryPage alloc] initWithFrame:self.view.bounds];
    [self.view addSubview: self.page];
    [self refreshPage];
}

-(void)refreshPage {
    [SVProgressHUD show];
    [MoneyAPI MoneyAPI_List:nil onSuccess:^(MoneyFlowList *resp) {
        [SVProgressHUD dismiss];
        [self.page setMoneyFlowList:resp];
    } onError:^(APIError *err) {
        [SVProgressHUD dismiss];
    }];
}

@end
