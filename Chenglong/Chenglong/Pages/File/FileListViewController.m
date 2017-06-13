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

@end

@implementation FileListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createPage];

    if(self.courseId == NULL) {
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
}

-(void)createPage {
    self.page = [[FileListPage alloc] initWithFrame:self.view.bounds];
    self.page.filePath = self.filePath;
    [self.view addSubview:self.page];
    
    NSString* fileName = [self jsonFileName];
    NSFileManager* fm = [NSFileManager defaultManager];
    if([fm fileExistsAtPath:fileName]){
        NSData* data = [fm contentsAtPath:fileName];
        NSError *error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:&error];
        ObjectMapper* mapper = [ObjectMapper mapper];
        CourseDetailsList* resp = [mapper mapObject:json toClass:[CourseDetailsList class] withError:&error];
        if(error)
            [self refreshPage];
        else {
            self.navigationItem.title = resp.courseDetails.course.title;
            [self.page setCourseDetailsList:resp];
        }
    }
    else
        [self refreshPage];
}

-(void)refreshPage {
    [CourseApi CourseAPI_ListUserCourses:NULL currentDirId:self.courseId page:0 onSuccess:^(CourseDetailsList *resp) {
        if(resp.courseDetails) {
            self.navigationItem.title = resp.courseDetails.course.title;
        }
        [self.page setCourseDetailsList:resp];
        
        NSString* fileName = [self jsonFileName];
        NSString* json = [resp toJson];
        [json writeToFile:fileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
    } onError:^(APIError *err) {
        
    }];
}

-(NSString*)jsonFileName {
    NSString* fileName = [self.filePath stringByAppendingFormat:@"/%@.json", self.courseId];
    return fileName;
}

@end
