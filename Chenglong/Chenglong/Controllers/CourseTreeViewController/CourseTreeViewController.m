//
//  CourseTreeViewController.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 7/26/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "CourseTreeViewController.h"
#import "CreateFileViewController.h"
#import "BaseNavigationController.h"
#import "MediaViewController.h"

@interface CourseTreeViewController ()


@end

@implementation CourseTreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect rect = self.view.bounds;
    rect.size.height = rect.size.height - 108;
    self.page = [[CourseTreePage alloc] initWithFrame:rect];
    if(self.userId == nil || [Global isLoginUser:self.userId]){
        self.title = @"我的文件";
    }
    else {
        self.title = @"用户文件";
    }
    
    [self.page.refreshControl addTarget:self action:@selector(refreshPage) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.page];
    self.view.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.page autoPinEdgesToSuperviewMargins];
    
    [self showPage];
    [super addTopRightMenu];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(courseAddedNoti:) name:NotificationCourseAdded object:NULL];
}

-(void)courseAddedNoti:(NSNotification*)noti {
    Course* course = noti.object;
    self.selectedCourseId = course.id;
    [self refreshPage];
}

-(NSMutableArray*)getTopRightMenuItems {
    NSMutableArray* menuItems = [[NSMutableArray alloc] init];
    CourseDetails* selected = [self.page.treeView itemForSelectedRow];
    if(self.userId == nil || [Global isLoginUser:self.userId] || [Global isSuperUser]){
        if(selected.course.isDir.boolValue) {
            [menuItems addObject:[[MenuItem alloc] initWithText:@"新文件" andImgName:@"file_item_newFile_icon"]] ;
            [menuItems addObject:[[MenuItem alloc] initWithText:@"新文件夹" andImgName:@"file_item_newfolder_icon"] ];
            if(selected.parent) {
                [menuItems addObject:[[MenuItem alloc] initWithText:@"删除" andImgName:@"file_item_remove_icon"]];
                [menuItems addObject:[[MenuItem alloc] initWithText:@"改名" andImgName:@"file_item_edit_icon"]];
                [menuItems addObject:[[MenuItem alloc] initWithText:@"移动" andImgName:@"file_item_exchange_icon"]];
            }
            if(selected.items.count) {
                [menuItems addObject:[[MenuItem alloc] initWithText:@"播放" andImgName:@"file_item_play_icon"]];
            }
            [menuItems addObject:[[MenuItem alloc] initWithText:@"拷贝" andImgName:@"file_item_download_icon"]];
        }
        else {
            [menuItems addObject:[[MenuItem alloc] initWithText:@"播放" andImgName:@"file_item_play_icon"]];
            [menuItems addObject:[[MenuItem alloc] initWithText:@"删除" andImgName:@"file_item_remove_icon"]];
            [menuItems addObject:[[MenuItem alloc] initWithText:@"改名" andImgName:@"file_item_edit_icon"]];
            [menuItems addObject:[[MenuItem alloc] initWithText:@"移动" andImgName:@"file_item_exchange_icon"]];
            [menuItems addObject:[[MenuItem alloc] initWithText:@"拷贝" andImgName:@"file_item_download_icon"]];
        }
    }
    else {
        [menuItems addObject:[[MenuItem alloc] initWithText:@"拷贝" andImgName:@"file_item_download_icon"]];
    }
    return menuItems;
}

-(void)topRightMenuItemClicked:(NSString *)cmd {
    NSLog(@"cmd %@ clicked", cmd);
    CourseDetails* selected = [self.page.treeView itemForSelectedRow];
    if(selected.course.isDir.boolValue) {
        if ([cmd isEqualToString:@"新文件"]) {
            CreateFileViewController *file = [CreateFileViewController loadFromNib];
            file.parentCourseId = selected.course.id;
            BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:file];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }
        else if([cmd isEqualToString:@"新文件夹"]){
            //新建文件夹
            [self creatCourseDir:selected];
        }
        else if ([cmd isEqualToString:@"改名"]){
            //改名
            [self changeCourseName:selected];
        }
        else if ([cmd isEqualToString:@"移动"]){
            [self moveCourse:selected];
        }
        else if ([cmd isEqualToString:@"播放"]){
            [self playCourse:selected];
        }
        else if ([cmd isEqualToString:@"删除"]) {
            if(selected.items.count>0) {
                [self presentFailureTips:@"当前文件夹为空时才能删除"];
                return;
            }
            [self removeCourse:selected];
        }
    } else {
        if([cmd isEqualToString:@"删除"]) {
            [self removeCourse:selected];
        }
        else if([cmd isEqualToString:@"改名"]) {
            [self changeCourseName:selected];
        }
        else if([cmd isEqualToString:@"移动"]) {
        }
        else if([cmd isEqualToString:@"播放"]) {
            [self playCourse:selected];
        }
    }
}

-(void)creatCourseDir:(CourseDetails*)cd {
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
        course.parentCourseId = cd.course.id;
        [SVProgressHUD showWithStatus:@"创建中"];
        [CourseApi CourseAPI_CreateCourseDir:course onSuccess:^(Course *resp) {
            [SVProgressHUD dismiss];
            weakSelf.selectedCourseId = resp.id;
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

-(void)changeCourseName:(CourseDetails*)cd {
}

-(void)playCourse:(CourseDetails*)cd {
    MediaViewController* c = [MediaViewController new];
    c.courseDetails = cd;
    [self.navigationController presentViewController:c animated:YES completion:^{
        
    }];
}

-(void)moveCourse:(CourseDetails*)cd {
}

-(void)removeCourse:(CourseDetails*)cd {
    WeakSelf(weakSelf)
    NSString* title = [NSString stringWithFormat:@"确认删除 %@?", cd.course.title];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除" message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:actionCancel];
    UIAlertAction *actionSure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [CourseApi CourseAPI_RemoveCourse:cd.course.id onSuccess:^(Course *resp) {
            [weakSelf presentFailureTips:@"删除成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            CourseDetails* parent = [weakSelf.page deleteCourse:resp.id];
            weakSelf.selectedCourseId = parent.course.id;
            [weakSelf refreshPage];
        } onError:^(APIError *err) {
            ALERT_VIEW_WITH_TITLE(err.errorCode, err.errorMsg);
        }];
    }];
    [alert addAction:actionSure];
    [[self getCurrentNavController] presentViewController:alert animated:YES completion:^{
    }];
}


-(void)refreshPage {
    [MyHTTPSessionManager disableCacheForSeconds:3];
    [self showPage];
}

-(void)showPage {
    [CourseApi CourseAPI_ListUserCourseTree:self.userId onSuccess:^(CourseDetails *resp) {
        resp.course = [Course new];
        resp.course.isDir = [NSNumber numberWithInteger:1];
        
        if(self.userId == NULL || [Global isLoginUser:self.userId]){
            resp.course.title = [NSString stringWithFormat:@"我的文件"];
        }
        else {
            resp.course.title = [NSString stringWithFormat:@"%@的文件", resp.user.name];
        }
        
        CourseDetails* container = [CourseDetails new];
        container.items = [NSMutableArray arrayWithObject:resp];
        self.page.courseDetails = container;
        [self.page.refreshControl endRefreshing];
            [self.page selectCourse:self.selectedCourseId];
    } onError:^(APIError *err) {
        ALERT_VIEW_WITH_TITLE(err.errorCode, err.errorMsg);
        [self.page.refreshControl endRefreshing];
    }];
}

-(BOOL)isSameViewController:(UIViewController*)c
{
    if(![c isKindOfClass:[CourseTreeViewController class]]) {
        return NO;
    }
    CourseTreeViewController* ctc = c;
    if(self.userId == NULL && ctc.userId == NULL)
        return YES;
    if(self.userId != NULL && ctc.userId == NULL) {
        if([Global isLoginUser:self.userId])
            return YES;
        else
            return NO;
    }
    if(self.userId == NULL && ctc.userId != NULL) {
        if([Global isLoginUser:ctc.userId])
            return YES;
        else
            return NO;
    }
    return [self.userId isEqualToString:ctc.userId];
}

-(BOOL)hidesBottomBarWhenPushed
{
    if(self.navigationController.viewControllers.count==1 && [self.navigationController.viewControllers lastObject] == self)
        return NO;
    return YES;
}
@end
