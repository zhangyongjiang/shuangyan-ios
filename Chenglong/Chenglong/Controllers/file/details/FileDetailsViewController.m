//
//  FileDetailsViewController.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "FileDetailsViewController.h"
#import "MediaContentAudioView.h"
#import "courseView.h"
#import "CoursePickerViewController.h"
#import "MediaViewController.h"
#import "BaseNavigationController.h"
#import "UpdateFileViewController.h"
#import "CourseTreeViewController.h"
#import "CoursePickerViewController.h"
#import "CourseView.h"

@interface FileDetailsViewController () <UIImagePickerControllerDelegate, CousePickerDelegate>

@property(strong, nonatomic) CourseView* courseView;
@property(strong, nonatomic) CoursePickerViewController* coursePickerViewController;

@end

@implementation FileDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.courseDetails.course.title;
    
    WeakSelf(weakSelf)
    CGRect frame = self.view.bounds;
    frame.size.height -= 104;
    self.courseView = [[CourseView alloc] initWithFrame:frame];
    self.courseView.courseDetails = self.courseDetails;
    [self.view addSubview:self.courseView];
    
    [self addTopRightMenu];
}

-(void)removeResource:(MediaContent*)lmc {
    WeakSelf(weakSelf)
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:actionCancel];
    UIAlertAction *actionSure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        Course* c = [Course new];
        c.id = self.courseView.courseDetails.course.id;
        c.resources = [NSMutableArray new];
        [c.resources addObject:lmc];
        [CourseApi CourseAPI_RemoveResources:c onSuccess:^(Course *resp) {
            [weakSelf presentFailureTips:@"删除成功"];
            for (int i=0; i<self.courseView.courseDetails.course.resources.count; i++) {
                MediaContent* mc = [self.courseView.courseDetails.course.resources objectAtIndex:i];
                if([mc.path isEqualToString:lmc.path]) {
                    [self.courseView.courseDetails.course.resources removeObjectAtIndex:i];
                    break;
                }
            }
            self.courseView.courseDetails = self.courseView.courseDetails;
        } onError:^(APIError *err) {
        }];
    }];
    [alert addAction:actionSure];
    [[self getCurrentNavController] presentViewController:alert animated:YES completion:^{
        
    }];
}

-(void)addTopRightMenu {
    if([Global isLoginUser:self.courseDetails.course.userId]) {
        NSMutableArray* arr = [NSMutableArray arrayWithObjects:
                               [[MenuItem alloc] initWithText:@"修改" andImgName:@"file_item_edit_icon"],
                               [[MenuItem alloc] initWithText:@"删除" andImgName:@"file_item_remove_icon"],
                               [[MenuItem alloc] initWithText:@"删除下载" andImgName:@"file_item_remove_icon"],
                               [[MenuItem alloc] initWithText:@"上传" andImgName:@"file_item_exchange_icon"],
                               [[MenuItem alloc] initWithText:@"下载全部" andImgName:@"file_item_exchange_icon"],
                               [[MenuItem alloc] initWithText:@"全屏" andImgName:@"file_item_exchange_icon"],
                               [[MenuItem alloc] initWithText:@"移动" andImgName:@"file_item_exchange_icon"],
                               nil];
        self.menuItems = arr;
        [super addTopRightMenu:arr];
        
        [self enableMenuItem:@"下载全部" enable:![self isAllDownloaded]];
    }
    else {
        NSMutableArray* arr = [NSMutableArray arrayWithObjects:
                               [[MenuItem alloc] initWithText:@"拷贝" andImgName:@"file_item_newFile_icon"],
                               [[MenuItem alloc] initWithText:@"上传者" andImgName:@"file_search_age_icon"],
                               nil];
        self.menuItems = arr;
        [super addTopRightMenu:arr];
    }
}

-(BOOL)isAllDownloaded {
    for (LocalMediaContent* mc in self.courseDetails.course.resources) {
        if(![mc isDownloaded])
            return NO;
    }
    return YES;
}

-(void)removeDownloads
{
    for (LocalMediaContent* mc in self.courseDetails.course.resources) {
        File* f = [[File alloc] initWithFullPath:mc.localFilePath];
        [f remove];
    }
}


-(void)topRightMenuItemClicked:(NSString *)cmd {
    [super topRightMenuItemClicked:cmd];
    if ([cmd isEqualToString:@"删除"]) {
        [self removeCourse];
    }
    if ([cmd isEqualToString:@"删除下载"]) {
        [self removeDownloads];
    }
    else if([cmd isEqualToString:@"修改"]){
        [self showUpdateCourse];
    }
    else if([cmd isEqualToString:@"全屏"]){
        [[MediaPlayer shared] stop];
        MediaViewController* c = [MediaViewController new];
        c.courseDetails = self.courseDetails;
        [self.navigationController presentViewController:c animated:YES completion:^{
            
        }];
    }
    else if([cmd isEqualToString:@"上传"]){
        [self upload];
    }
    else if([cmd isEqualToString:@"移动"]){
        [self move];
    }
    else if([cmd isEqualToString:@"下载全部"]){
//        [self.courseView downloadAll];
    }
    else if ([cmd isEqualToString:@"拷贝"]) {
        self.coursePickerViewController = [[CoursePickerViewController alloc] init];
        [self.navigationController pushViewController:self.coursePickerViewController animated:YES];
        self.coursePickerViewController.delegate = self;
    }
    else if ([cmd isEqualToString:@"上传者"]){
        CourseTreeViewController* controller = [CourseTreeViewController new];
        controller.userId = self.courseDetails.course.userId;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

-(void)move {
    CoursePickerViewController* c = [CoursePickerViewController new];
    c.delegate = self;
    [self.navigationController pushViewController:c animated:YES];
}

-(void)selectCourse:(NSString *)courseId {
    CourseMoveRequest* req = [CourseMoveRequest new];
    req.courseId = self.courseDetails.course.id;
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

-(void)upload {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

-(void)showUpdateCourse
{
    UpdateFileViewController *file = [[UpdateFileViewController alloc] initWithNibName:@"CreateFileViewController" bundle:nil];
    file.courseDetails = self.courseDetails;
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:file];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)changeCourseName
{
    WeakSelf(weakSelf)
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改文件名称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = weakSelf.courseDetails.course.title;
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
        request.courseId = weakSelf.courseDetails.course.id;
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
        [CourseApi CourseAPI_RemoveCourse:self.courseDetails.course.id onSuccess:^(Course *resp) {
            [self presentFailureTips:@"删除成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationCourseChanged object:resp];
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
        textField.text = weakSelf.courseDetails.course.title;
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
        request.courseId = weakSelf.courseDetails.course.id;
        request.name = tf.text;
        [CourseApi CourseAPI_RenameCourse:request onSuccess:^(Course *resp) {
            weakSelf.title = resp.title;
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationCourseChanged object:resp];
        } onError:^(APIError *err) {
            ALERT_VIEW_WITH_TITLE(err.errorCode, err.errorMsg);
        }];
    }];
    [alert addAction:actionSure];
    [[self getCurrentNavController] presentViewController:alert animated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    NSData* data = UIImageJPEGRepresentation(chosenImage, [Config shared].defaultImageQuality);
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:data, @"file", @"test.jpeg", @"filename", nil];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [CourseApi CourseAPI_AddResourceToCourse:dict courseId:self.courseDetails.course.id onSuccess:^(Course *resp) {
        [self presentFailureTips:@"上传成功"];
        self.courseDetails.course.resources = resp.resources;
        self.courseView.courseDetails = self.courseDetails;
    } onError:^(APIError *err) {
        NSLog(@"上传失败\n%@", err);
        [self presentFailureTips:@"上传失败"];
    } progress:^(NSProgress *progress) {
        
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
