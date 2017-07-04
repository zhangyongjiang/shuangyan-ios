//
//  UserFileListViewController.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "UserFileListViewController.h"
#import "ObjectMapper.h"
#import "CreateFileViewController.h"
#import "CoursePickerViewController.h"
#import "OnlineFileDetailsViewController.h"

@interface UserFileListViewController ()

@property(strong, nonatomic) UserFileListPage* page;

@end

@implementation UserFileListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createPage];
    [self addTopRightMenu];
    self.title = @"用户根目录文件";
}

-(void)addTopRightMenu {
    self.menuItems = [[NSMutableArray alloc] init];
    NSMutableArray* arr = self.menuItems;
    [arr addObject:[[MenuItem alloc] initWithText:@"上传者" andImgName:@"file_search_age_icon"] ];
    [arr addObject:[[MenuItem alloc] initWithText:@"拷贝到..." andImgName:@"file_item_newFile_icon"]] ;
    
    [super addTopRightMenu:arr];
}

-(void)topRightMenuItemClicked:(NSString *)cmd {
    [super topRightMenuItemClicked:cmd];
    if ([cmd hasPrefix:@"拷贝"]) {
    }
    else if([cmd isEqualToString:@"上传者"]){
    }
}

-(void)createPage {
    self.page = [[UserFileListPage alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.page];
    
    [self refreshPage];
}

-(void)refreshPage {
    [CourseApi CourseAPI_ListUserCourses:self.userId currentDirId:nil page:nil onSuccess:^(CourseDetailsList *resp) {
        self.page.courseDetailsList = resp;
        
    } onError:^(APIError *err) {
        
    }];
}

@end
