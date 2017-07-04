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

@interface FileDetailsViewController () <UIImagePickerControllerDelegate>

@property(strong, nonatomic) CourseDetailsView* courseDetailsView;

@end

@implementation FileDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.localCourseDetails.courseDetails.course.title;

    WeakSelf(weakSelf)
    self.courseDetailsView = [[CourseDetailsView alloc] initWithFrame:self.view.bounds];
    self.courseDetailsView.localCourseDetails = self.localCourseDetails;
    [self.view addSubview:self.courseDetailsView];
    [self.courseDetailsView addRemoveResourceHandler:^(LocalMediaContent *localMediaContent) {
        [weakSelf removeResource:localMediaContent];
    }];
    
    [self addTopRightMenu];
}

-(void)removeResource:(LocalMediaContent*)lmc {
    Course* c = [Course new];
    c.id = self.courseDetailsView.localCourseDetails.courseDetails.course.id;
    c.resources = [NSMutableArray new];
    [c.resources addObject:lmc.mediaContent];
    WeakSelf(weakSelf)
    [CourseApi CourseAPI_RemoveResources:c onSuccess:^(Course *resp) {
        [weakSelf presentFailureTips:@"删除成功"];
        int i =0;
        for (MediaContent* mc in self.courseDetailsView.localCourseDetails.courseDetails.course.resources) {
            if([mc.path isEqualToString:lmc.mediaContent.path]) {
                [self.courseDetailsView.localCourseDetails.courseDetails.course.resources removeObjectAtIndex:i];
            }
            i++;
        }
        self.courseDetailsView.localCourseDetails = self.courseDetailsView.localCourseDetails;
    } onError:^(APIError *err) {
    }];
}

-(void)addTopRightMenu {
    NSMutableArray* arr = [NSMutableArray arrayWithObjects:
                           [[MenuItem alloc] initWithText:@"改名" andImgName:@"file_item_edit_icon"],
                           [[MenuItem alloc] initWithText:@"删除" andImgName:@"file_item_remove_icon"],
                           [[MenuItem alloc] initWithText:@"上传" andImgName:@"file_item_exchange_icon"],
                           [[MenuItem alloc] initWithText:@"下载全部" andImgName:@"file_item_exchange_icon"],
                           nil];
    self.menuItems = arr;
    [super addTopRightMenu:arr];
    
    [self enableMenuItem:@"下载全部" enable:![self isAllDownloaded]];
}

-(BOOL)isAllDownloaded {
    for (MediaContent* mc in self.localCourseDetails.courseDetails.course.resources) {
        LocalMediaContent* lmc = [[LocalMediaContent alloc] initWithMediaContent:mc];
        if(![lmc isDownloaded])
            return NO;
    }
    return YES;
}


-(void)topRightMenuItemClicked:(NSString *)cmd {
    [super topRightMenuItemClicked:cmd];
    if ([cmd isEqualToString:@"删除"]) {
        [self removeCourse];
    }
    else if([cmd isEqualToString:@"改名"]){
        [self changeCourseName];
    }
    else if([cmd isEqualToString:@"上传"]){
        [self upload];
    }
    else if([cmd isEqualToString:@"下载全部"]){
        [self.courseDetailsView downloadAll];
    }
}

-(void)upload {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
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
    [CourseApi CourseAPI_AddResourceToCourse:dict courseId:self.localCourseDetails.courseDetails.course.id onSuccess:^(Course *resp) {
        
    } onError:^(APIError *err) {
        
    } progress:^(NSProgress *progress) {
        
    }];
}


@end
