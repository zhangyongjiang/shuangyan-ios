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

@interface OnlineSearchListViewController ()

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiSearchHandler:) name:NotificationSearch object:nil];
}

-(void)notiSearchHandler:(NSNotification*)noti {
    NSString* keywords = noti.object;
    self.keywords = keywords;
    [self refreshPage];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"共享";
}

-(void)createPage {
    self.page = [[OnlineSearchListPage alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.page];
    
    [self refreshPage];
}

-(void)refreshPage {
    self.currentPage = 0;
    [CourseApi CourseAPI_Search:self.keywords age:nil page:nil onSuccess:^(CourseDetailsList *resp) {
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
    [CourseApi CourseAPI_Search:self.keywords age:nil page:[NSNumber numberWithInt:self.currentPage] onSuccess:^(CourseDetailsList *resp) {
        [self.page appendCourseDetailsList:resp];
    } onError:^(APIError *err) {
        
    }];

}

-(BOOL)hidesBottomBarWhenPushed
{
    if(self.navigationController.viewControllers.count==1 && [self.navigationController.viewControllers lastObject] == self)
        return NO;
    return YES;
}
@end
