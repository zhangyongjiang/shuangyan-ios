//
//  FileListViewController.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "FileListViewController.h"
#import "ObjectMapper.h"

@interface FileListViewController ()

@property(strong, nonatomic) FileListPage* page;
@property(strong, nonatomic) NSString* dirPath;

@end

@implementation FileListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createPage];

    if(self.currentDirId == NULL) {
        self.navigationItem.title = @"我的";
    }
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[[UIImage imageNamed:@"tab_btn_file_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tab_btn_file_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    self.tabBarItem.imageInsets = UIEdgeInsetsMake(-4, 0, 4, 0);
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if(self.currentDirId == NULL) {
        self.dirPath = NSHomeDirectory();
        [filemgr changeCurrentDirectoryPath:self.dirPath];
    }
    else {
        self.dirPath = [NSString stringWithFormat:@"%@/%@", [filemgr currentDirectoryPath], self.currentDirId];
        if(![filemgr fileExistsAtPath:self.dirPath]) {
            [filemgr createDirectoryAtPath:self.dirPath withIntermediateDirectories:FALSE attributes:nil error:nil];
        }
        [filemgr changeCurrentDirectoryPath:self.dirPath];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)createPage {
    self.page = [[FileListPage alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.page];
    [self refreshPage];
}

-(void)refreshPage {
    [CourseApi CourseAPI_ListUserCourses:NULL currentDirId:self.currentDirId page:0 onSuccess:^(CourseDetailsList *resp) {
        if(resp.courseDetails) {
            self.navigationItem.title = resp.courseDetails.course.title;
        }
        [self.page setCourseDetailsList:resp];

//        if(self.currentDirId != NULL) {
//            NSFileManager *filemgr = [NSFileManager defaultManager];
//            NSString* currPath = [filemgr currentDirectoryPath];
//            NSString* nodeFilePath = [NSString stringWithFormat:@"%@/.info", currPath];
//            NSString* json = [resp.courseDetails toJson];
//            [json writeToFile:nodeFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
//        }
    } onError:^(APIError *err) {
        
    }];
}

@end
