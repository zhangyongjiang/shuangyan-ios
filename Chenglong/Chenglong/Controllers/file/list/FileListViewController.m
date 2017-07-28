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
#import "UpdateFileViewController.h"
#import "FileManager.h"
#import "File.h"
#import "BaseNavigationController.h"
#import "CoursePickerViewController.h"
#import "MediaViewController.h"

@interface FileListViewController () <CousePickerDelegate>

@property(strong, nonatomic) FileListPage* page;
@property(strong, nonatomic) NSMutableArray* downloadList;
@property(assign, nonatomic) int currentDownload;

@end

@implementation FileListViewController

- (void)viewDidLoad {
    self.currentDownload = 0;
    self.downloadList = [NSMutableArray new];
    [super viewDidLoad];
    [self addTopRightMenu];
    [self createPage];

    if(self.courseId == NULL) {
        self.navigationItem.title = @"我的文件";
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(courseChangedNoti:) name:NotificationCourseChanged object:NULL];
}

-(void)courseChangedNoti:(NSNotification*)noti {
    WeakSelf(weakSelf)
    Course* course = noti.object;
    User* user = [Global loggedInUser];
    BOOL refresh = NO;
    for (CourseDetails* cd in self.page.courseDetailsList.items) {
        if([cd.course.id isEqualToString:course.id]) {
            refresh = YES;
            break;
        }
    }
    if(weakSelf.courseId == NULL && [user.id isEqualToString:course.userId] && course.parentCourseId == NULL) {
        refresh = YES;
    }
    if(refresh)
        [weakSelf refreshPage];
}

-(void)addTopRightMenu {
    self.menuItems = [[NSMutableArray alloc] init];
    [self.menuItems addObject:[[MenuItem alloc] initWithText:@"新文件" andImgName:@"file_item_newFile_icon"]] ;
    [self.menuItems addObject:[[MenuItem alloc] initWithText:@"新文件夹" andImgName:@"file_item_newfolder_icon"] ];
    [self.menuItems addObject:[[MenuItem alloc] initWithText:@"删除" andImgName:@"file_item_remove_icon"]];
//    [self.menuItems addObject:[[MenuItem alloc] initWithText:@"播放" andImgName:@"file_item_play_icon"] ];
    [self.menuItems addObject:[[MenuItem alloc] initWithText:@"改名" andImgName:@"file_item_edit_icon"]];
    [self.menuItems addObject:[[MenuItem alloc] initWithText:@"移动" andImgName:@"file_item_exchange_icon"]];
    [self.menuItems addObject:[[MenuItem alloc] initWithText:@"播放" andImgName:@"file_item_play_icon"]];
    [self.menuItems addObject:[[MenuItem alloc] initWithText:@"下载全部" andImgName:@"file_item_download_icon"]],

    [super addTopRightMenu:self.menuItems];
}

-(void)displayData:(CourseDetailsList*)list {
    [self.page setCourseDetailsList:list];
    [self enableMenuItem:@"改名" enable:(self.courseId!=NULL)];
    [self enableMenuItem:@"删除" enable:(self.courseId!=NULL)];
    if(list.items.count == 0) {
        if(self.courseId == NULL) {
            WeakSelf(weakSelf)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 100*NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
                [weakSelf popMenu];
            });
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)createPage {
    CGRect frame = self.view.bounds;
    frame.size.height -= 64;
    self.page = [[FileListPage alloc] initWithFrame:frame];
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
                [self displayData:resp];
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
        [self displayData:resp];
        
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

-(void)resetFolderName
{
    UpdateFileViewController *file = [[UpdateFileViewController alloc] initWithNibName:@"CreateFileViewController" bundle:nil];
    file.courseDetails = self.page.courseDetailsList.courseDetails;
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:file];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)resetFolderNameDirectly
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
        [CourseApi CourseAPI_RenameCourse:request onSuccess:^(Course *resp) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationCourseChanged object:resp];
            [self refreshPage];
        } onError:^(APIError *err) {
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
    else if ([cmd isEqualToString:@"下载全部"]){
        [self downloadAll];
    }
    else if ([cmd isEqualToString:@"移动"]){
        [self move];
    }
    else if ([cmd isEqualToString:@"播放"]){
        [self play];
    }
    else if ([cmd isEqualToString:@"删除"]) {
        if(self.page.courseDetailsList.items.count>0) {
            [self presentFailureTips:@"当前文件夹为空时才能删除"];
            return;
        }
        [self removeCourse];
    }
}

-(void)play
{
    NSMutableArray* mediaContents = [NSMutableArray arrayWithCapacity:0];
    for (CourseDetails* cd in self.page.courseDetailsList.items) {
        for (MediaContent* mc in cd.course.resources) {
            if([mc.contentType hasPrefix:@"audio"] || [mc.contentType hasPrefix:@"video"]) {
                if([mc isDownloaded])
                    [mediaContents addObject:mc];
            }
        }
    }
    if (mediaContents.count == 0) {
        [self presentFailureTips:@"先下载"];
        return;
    }
    MediaViewController* c = [MediaViewController new];
    c.mediaContents = mediaContents;
    [self.navigationController presentViewController:c animated:YES completion:^{
        NSLog(@"completed");
        [c play];
    }];
}

-(void)move {
    CoursePickerViewController* c = [CoursePickerViewController new];
    c.delegate = self;
    [self.navigationController pushViewController:c animated:YES];
}

-(void)selectCourse:(NSString *)courseId {
    CourseMoveRequest* req = [CourseMoveRequest new];
    req.courseId = self.courseId;
    req.targetParentCourseId = courseId;
    WeakSelf(weakSelf)
    [CourseApi CourseAPI_MoveCourse:req onSuccess:^(Course *resp) {
        [weakSelf presentFailureTips:@"移动成功"];
        [weakSelf.navigationController popToViewController:weakSelf animated:YES];
    } onError:^(APIError *err) {
        [weakSelf presentFailureTips:@"移动失败"];
        [weakSelf.navigationController popToViewController:weakSelf animated:YES];
    }];
}

-(void)downloadAll {
    for (CourseDetails* cd in self.page.courseDetailsList.items) {
        if(!cd.course.resources)
            continue;
        [self.downloadList addObjectsFromArray:cd.course.resources];
    }
    [self downloadOne];
}

-(void)downloadOne {
    if(self.currentDownload >= self.downloadList.count)
        return;
    MediaContent* mc = [self.downloadList objectAtIndex:self.currentDownload];
    WeakSelf(weakSelf)
    NSLog(@"download %@", mc.path);
        [mc downloadWithProgressBlock:^(CGFloat progress) {
            NSLog(@"download %f", progress);
        } completionBlock:^(BOOL completed) {
            NSLog(@"download complete");
            self.currentDownload++;
            [weakSelf downloadOne];
        }];
}

-(void)removeCourse {
    WeakSelf(weakSelf)
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {        
    }];
    [alert addAction:actionCancel];
    UIAlertAction *actionSure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [CourseApi CourseAPI_RemoveCourse:self.courseId onSuccess:^(Course *resp) {
            [self presentFailureTips:@"删除成功"];
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationCourseChanged object:resp];
        } onError:^(APIError *err) {
            ALERT_VIEW_WITH_TITLE(err.errorCode, err.errorMsg);
        }];
    }];
    [alert addAction:actionSure];
    [[self getCurrentNavController] presentViewController:alert animated:YES completion:^{
        
    }];

}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    self.page.size = size;
}

@end
