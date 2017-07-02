//
//  FileListViewController.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "FileListViewController.h"
#import "ObjectMapper.h"
#import "CreateFileViewController.h"
#import "FileManager.h"
#import "File.h"
#import "BaseNavigationController.h"

@interface FileListViewController ()

@property(strong, nonatomic) FileListPage* page;

@end

@implementation FileListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createPage];
    [self addTopRightMenu];

    if(self.courseId == NULL) {
        self.navigationItem.title = @"我的文件";
    }
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[[UIImage imageNamed:@"tab_btn_file_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tab_btn_file_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    self.tabBarItem.imageInsets = UIEdgeInsetsMake(-4, 0, 4, 0);
}

-(void)addTopRightMenu {
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    [arr addObject:[[MenuItem alloc] initWithText:@"新文件" andImgName:@"file_item_newFile_icon"]] ;
                    
    [arr addObject:[[MenuItem alloc] initWithText:@"新文件夹" andImgName:@"file_item_newfolder_icon"] ];
    
    if(self.courseId)
        [arr addObject:[[MenuItem alloc] initWithText:@"删除" andImgName:@"file_item_remove_icon"]];
     
    [arr addObject:[[MenuItem alloc] initWithText:@"播放" andImgName:@"file_item_play_icon"] ];

    if(self.courseId != NULL)
        [arr addObject:[[MenuItem alloc] initWithText:@"改名" andImgName:@"file_item_edit_icon"]];

    [super addTopRightMenu:arr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)createPage {
    self.page = [[FileListPage alloc] initWithFrame:self.view.bounds];
    self.page.filePath = self.filePath;
    [self.view addSubview:self.page];
    
    File* file = [[File alloc] initWithFullPath:[self jsonFileName]];
    if([file exists] && [[file lastModifiedTime] timeIntervalSinceNow]<3600){
        NSData* data = file.content;
        if(!data) {
            [self refreshPage];
        }
        else {
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
        NSError* err;
        File* file = [[File alloc] initWithFullPath:fileName];
        [file mkdirs];
        BOOL success = [json writeToFile:fileName atomically:YES encoding:NSUTF8StringEncoding error:&err];
        if(!success) {
            NSLog(@"%@", err);
        }
    } onError:^(APIError *err) {
        
    }];
}

-(NSString*)jsonFileName {
    NSString* fileName = [self.filePath stringByAppendingFormat:@"/.json"];
    return fileName;
}

- (void)creatFolderEvent
{
    WeakSelf(weakSelf)
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"文件名称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:actionCancel];
    UIAlertAction *actionSure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *tf = [alert.textFields firstObject];
        if ([NSString isEmpty:tf.text]) {
            [self presentFailureTips:@"文件标题不能为空"];
            return;
        }
        Course *course = [Course new];
        course.title = tf.text;
        course.parentCourseId = self.courseId;
        [SVProgressHUD showWithStatus:@"创建中"];
        [CourseApi CourseAPI_CreateCourseDir:course onSuccess:^(Course *resp) {
            
            [SVProgressHUD dismiss];
            
            [weakSelf refreshPage];
            
        } onError:^(APIError *err) {
            
            [SVProgressHUD dismiss];
            ALERT_VIEW_WITH_TITLE(err.errorCode, err.errorMsg);
        }];
    }];
    [alert addAction:actionSure];
    [[self getCurrentNavController] presentViewController:alert animated:YES completion:^{
        
    }];
}

- (void)resetFolderName
{
    WeakSelf(weakSelf)
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改文件名称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = weakSelf.page.courseDetailsList.courseDetails.course.title;
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:actionCancel];
    UIAlertAction *actionSure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *tf = [alert.textFields firstObject];
        if ([NSString isEmpty:tf.text]) {
            [self presentFailureTips:@"文件标题不能为空"];
            return;
        }
        RenameRequest *request = [RenameRequest new];
        request.courseId = weakSelf.courseId;
        request.name = tf.text;
        [SVProgressHUD showWithStatus:@"修改中"];
        [CourseApi CourseAPI_RenameCourse:request onSuccess:^(Course *resp) {
            [SVProgressHUD dismiss];
            [self refreshPage];
        } onError:^(APIError *err) {
            [SVProgressHUD dismiss];
            ALERT_VIEW_WITH_TITLE(err.errorCode, err.errorMsg);
        }];
    }];
    [alert addAction:actionSure];
    [[self getCurrentNavController] presentViewController:alert animated:YES completion:^{
        
    }];
}

-(void)topRightMenuItemClicked:(NSString *)cmd {
    [super topRightMenuItemClicked:cmd];
    if ([cmd isEqualToString:@"新文件"]) {
        CreateFileViewController *file = [CreateFileViewController loadFromNib];
        file.parentCourseId = self.courseId;
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:file];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
    else if([cmd isEqualToString:@"新文件夹"]){
        //新建文件夹
        [self creatFolderEvent];
    }
    else if ([cmd isEqualToString:@"改名"]){
        //改名
        [self resetFolderName];
    }
    else if ([cmd isEqualToString:@"删除"]) {
        if(self.page.courseDetailsList.items.count>0) {
            [self presentFailureTips:@"当前文件夹为空时才能删除"];
            return;
        }
        [CourseApi CourseAPI_RemoveCourse:self.courseId onSuccess:^(Course *resp) {
            [self presentFailureTips:@"删除成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } onError:^(APIError *err) {
            ALERT_VIEW_WITH_TITLE(err.errorCode, err.errorMsg);
        }];
    }

}


@end
