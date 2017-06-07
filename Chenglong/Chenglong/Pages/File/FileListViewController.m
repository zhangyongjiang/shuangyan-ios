//
//  FileListViewController.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "FileListViewController.h"

@interface FileListViewController ()

@property(strong, nonatomic) FileListPage* page;

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if(self.currentDirId == NULL) {
        NSString* currPath = NSHomeDirectory();
        if([filemgr changeCurrentDirectoryPath:currPath] == NO) {
            NSLog(@"Cannot change current directory");
        }
        else {
            NSLog(@"change current directory to HOME %@", currPath);
        }
    }
    else {
        NSString* currPath = [filemgr currentDirectoryPath];
        NSRange range = [currPath rangeOfString:self.currentDirId];
        if(range.location != NSNotFound) {
            currPath = [currPath substringToIndex:(range.location + range.length)];
            if([filemgr changeCurrentDirectoryPath:currPath] == NO) {
                NSLog(@"Cannot change current directory to %@", currPath);
            }
            else {
                NSLog(@"change current directory to %@", currPath);
            }
        }
        else {
            currPath = [NSString stringWithFormat:@"%@/%@", currPath, self.currentDirId];
            if(![filemgr fileExistsAtPath:currPath]) {
                [filemgr createDirectoryAtPath:currPath withIntermediateDirectories:FALSE attributes:nil error:nil];
            }
            if([filemgr changeCurrentDirectoryPath:currPath] == NO) {
                NSLog(@"Cannot change current directory to %@", currPath);
            }
            else {
                NSLog(@"change current directory to %@", currPath);
            }
        }
    }
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
    } onError:^(APIError *err) {
        
    }];
}

@end
