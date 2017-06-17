//
//  FileDetailsViewController.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "OnlineFileDetailsViewController.h"
#import "MediaContentAudioView.h"
#import "CourseDetailsView.h"

@interface OnlineFileDetailsViewController ()

@property(strong, nonatomic) CourseDetailsView* courseDetailsView;

@end

@implementation OnlineFileDetailsViewController

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
    [super addTopRightMenu:arr];
}

-(void)topRightMenuItemClicked:(NSString *)cmd {
    [super topRightMenuItemClicked:cmd];
    if ([cmd isEqualToString:@"删除"]) {
    }
    else if([cmd isEqualToString:@"播放"]){
//        [self.courseDetailsView play];
    }
    else if ([cmd isEqualToString:@"改名"]){
        [self changeName];
    }
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
