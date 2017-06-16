//
//  OnlineFileListViewController.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "OnlineFileListViewController.h"
#import "ObjectMapper.h"
#import "CreateFileViewController.h"

@interface OnlineFileListViewController () <UISearchResultsUpdating>

@property(strong, nonatomic) OnlineFileListPage* page;

@end

@implementation OnlineFileListViewController

- (void)viewDidLoad {
    self.title = @"社区";
    self.navigationItem.title = @"社区";
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"社区" image:[[UIImage imageNamed:@"tab_btn_community_norl"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tab_btn_community_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    self.tabBarItem.imageInsets = UIEdgeInsetsMake(-4, 0, 4, 0);
    [super viewDidLoad];
    self.definesPresentationContext = YES;
    [self createPage];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"社区";
}

-(void)createPage {
    self.page = [[OnlineFileListPage alloc] initWithFrame:self.view.bounds];
    self.page.searchController.searchResultsUpdater = self;
    [self.view addSubview:self.page];
    
    [self refreshPage];
}

-(void)refreshPage {
    [CourseApi CourseAPI_Search:nil age:nil page:nil onSuccess:^(CourseDetailsList *resp) {
        if(resp.courseDetails) {
            self.navigationItem.title = resp.courseDetails.course.title;
        }
        [self.page setCourseDetailsList:resp];
    } onError:^(APIError *err) {
        
    }];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString* keywords = self.page.searchController.searchBar.text;
    [CourseApi CourseAPI_Search:keywords age:nil page:nil onSuccess:^(CourseDetailsList *resp) {
        if(resp.courseDetails) {
            self.navigationItem.title = resp.courseDetails.course.title;
        }
        [self.page setCourseDetailsList:resp];
    } onError:^(APIError *err) {
        
    }];
}



@end
