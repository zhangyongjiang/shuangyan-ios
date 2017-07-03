//
//  FileDetailsViewController.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "FileDetailsViewController.h"
#import "MediaContentAudioView.h"
#import "CourseDetailsView.h"
#import "CoursePickerViewController.h"

@interface FileDetailsViewController ()

@property(strong, nonatomic) CourseDetailsView* courseDetailsView;

@end

@implementation FileDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.localCourseDetails.courseDetails.course.title;
    [self addTopRightMenu];

    self.courseDetailsView = [[CourseDetailsView alloc] initWithFrame:self.view.bounds];
    self.courseDetailsView.localCourseDetails = self.localCourseDetails;
    [self.view addSubview:self.courseDetailsView];
}

-(void)addTopRightMenu {
    NSMutableArray* arr = [NSMutableArray arrayWithObjects:
                           [[MenuItem alloc] initWithText:@"改名" andImgName:@"file_item_edit_icon"],
                           [[MenuItem alloc] initWithText:@"播放" andImgName:@"file_item_play_icon"],
                           [[MenuItem alloc] initWithText:@"删除" andImgName:@"file_item_remove_icon"],
                           nil];
    self.menuItems = arr;
    [super addTopRightMenu:arr];
}

-(void)topRightMenuItemClicked:(NSString *)cmd {
    [super topRightMenuItemClicked:cmd];
    if ([cmd isEqualToString:@"删除"]) {
        [self removeCourse];
    }
    else if([cmd isEqualToString:@"改名"]){
        [self changeCourseName];
    }
}

- (void)changeCourseName
{
    WeakSelf(weakSelf)
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改文件名称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = weakSelf.localCourseDetails.courseDetails.course.title;
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
        request.courseId = weakSelf.localCourseDetails.courseDetails.course.id;
        request.name = tf.text;
        [CourseApi CourseAPI_RenameCourse:request onSuccess:^(Course *resp) {
            weakSelf.title = resp.title;
        } onError:^(APIError *err) {
            ALERT_VIEW_WITH_TITLE(err.errorCode, err.errorMsg);
        }];
    }];
    [alert addAction:actionSure];
    [[self getCurrentNavController] presentViewController:alert animated:YES completion:^{
        
    }];
}

-(void)removeCourse {
    WeakSelf(weakSelf)
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:actionCancel];
    UIAlertAction *actionSure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [CourseApi CourseAPI_RemoveCourse:self.localCourseDetails.courseDetails.course.id onSuccess:^(Course *resp) {
            [self presentFailureTips:@"删除成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } onError:^(APIError *err) {
            ALERT_VIEW_WITH_TITLE(err.errorCode, err.errorMsg);
        }];
    }];
    [alert addAction:actionSure];
    [[self getCurrentNavController] presentViewController:alert animated:YES completion:^{
        
    }];
    
}

-(void)changeName {
    WeakSelf(weakSelf)
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改文件名称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = weakSelf.localCourseDetails.courseDetails.course.title;
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
        request.courseId = weakSelf.localCourseDetails.courseDetails.course.id;
        request.name = tf.text;
        [SVProgressHUD showWithStatus:@"修改中"];
        [CourseApi CourseAPI_RenameCourse:request onSuccess:^(Course *resp) {
            [SVProgressHUD dismiss];
            weakSelf.title = resp.title;
        } onError:^(APIError *err) {
            [SVProgressHUD dismiss];
            ALERT_VIEW_WITH_TITLE(err.errorCode, err.errorMsg);
        }];
    }];
    [alert addAction:actionSure];
    [[self getCurrentNavController] presentViewController:alert animated:YES completion:^{
        
    }];
}


@end
