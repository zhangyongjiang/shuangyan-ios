//
//  OnlineFileListViewController.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "OnlineSearchListViewController.h"
#import "ObjectMapper.h"
#import "CreateFileViewController.h"

@interface OnlineSearchListViewController () <UISearchResultsUpdating>

@property(strong, nonatomic) OnlineSearchListPage* page;
@property(assign, nonatomic)int currentPage;
@property(strong, nonatomic) NSString* keywords;

@end

@implementation OnlineSearchListViewController

-(id)init {
    self = [super init];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.definesPresentationContext = YES;
    [self createPage];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"共享";
}

-(void)createPage {
    self.page = [[OnlineSearchListPage alloc] initWithFrame:self.view.bounds];
    self.page.searchController.searchResultsUpdater = self;
    [self.view addSubview:self.page];
    
    [self refreshPage];
}

-(void)refreshPage {
    self.currentPage = 0;
    [CourseApi CourseAPI_Search:nil age:nil page:nil onSuccess:^(CourseDetailsList *resp) {
        if(resp.courseDetails) {
            self.navigationItem.title = resp.courseDetails.course.title;
        }
        [self.page setCourseDetailsList:resp];
    } onError:^(APIError *err) {
        
    }];
}

-(void)nextPage {
    if(![self hasNextPage:PageSize current:self.currentPage currentItems:self.page.courseDetailsList.items.count]) {
        return;
    }
    self.currentPage++;
    [CourseApi CourseAPI_Search:nil age:nil page:[NSNumber numberWithInt:self.currentPage] onSuccess:^(CourseDetailsList *resp) {
        [self.page appendCourseDetailsList:resp];
    } onError:^(APIError *err) {
        
    }];

}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString* keywords = self.page.searchController.searchBar.text;
    if([keywords trim].length == 0)
        keywords = NULL;
    if(self.keywords == NULL && keywords == NULL)
        return;
    if(self.keywords != NULL && [self.keywords caseInsensitiveCompare:keywords] == NSOrderedSame)
        return;
    self.keywords = keywords;
    [CourseApi CourseAPI_Search:keywords age:nil page:nil onSuccess:^(CourseDetailsList *resp) {
        if(resp.courseDetails) {
            self.navigationItem.title = resp.courseDetails.course.title;
        }
        [self.page setCourseDetailsList:resp];
    } onError:^(APIError *err) {
        
    }];
}



@end
