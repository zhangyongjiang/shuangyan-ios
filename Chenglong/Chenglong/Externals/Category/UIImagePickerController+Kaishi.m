//
//  UIImagePickerController+Kaishi.m
//  Kaishi
//
//  Created by Hyun Cho on 2/2/16.
//  Copyright © 2016 BCGDV. All rights reserved.
//

#import "UIImagePickerController+Kaishi.h"

@implementation UIImagePickerController (Kaishi)

+ (void)showImagePickerOptionsFromViewController:(UIViewController*)viewController cameraSelected:(PickerOptionSelected)cameraSelected withLibrarySelected:(PickerOptionSelected)librarySelected {
    
    if ( [UIAlertController class] ) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *chooseExistingPhotoAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if ( librarySelected ) {
                librarySelected(viewController);
            }
        }];
        [alertController addAction:chooseExistingPhotoAction];
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if ( cameraSelected ) {
                    cameraSelected(viewController);
                }
            }];
            [alertController addAction:takePhotoAction];
        }
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancel];
        
        [viewController presentViewController:alertController animated:YES completion:nil];
        
    } else {
        UIActionSheet *actionSheet = [UIActionSheet bk_actionSheetWithTitle:nil];
        
        [actionSheet bk_addButtonWithTitle:@"从手机相册选择" handler:^{
            if ( librarySelected ) {
                librarySelected(viewController);
            }
        }];
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [actionSheet bk_addButtonWithTitle:@"拍照" handler:^{
                if ( cameraSelected ){
                    cameraSelected(viewController);
                }
            }];
        }
        
        [actionSheet bk_setCancelButtonWithTitle:@"取消" handler:nil];
        
        [actionSheet showInView:viewController.view];
    }
}


+ (void)showVideoPickerOptionsFromViewController:(UIViewController*)viewController cameraSelected:(PickerOptionSelected)cameraSelected withLibrarySelected:(PickerOptionSelected)librarySelected {
    if ( [UIAlertController class] ) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *chooseExistingVideoAction = [UIAlertAction actionWithTitle:@"选择你的视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if ( librarySelected ) {
                librarySelected(viewController);
            }
        }];
        [alertController addAction:chooseExistingVideoAction];
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertAction *recordVideoAction = [UIAlertAction actionWithTitle:@"录制视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if ( cameraSelected ) {
                    cameraSelected(viewController);
                }
            }];
            [alertController addAction:recordVideoAction];
        }
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancel];
        
        [viewController presentViewController:alertController animated:YES completion:nil];
        
    } else {
        UIActionSheet *actionSheet = [UIActionSheet bk_actionSheetWithTitle:nil];
        
        [actionSheet bk_addButtonWithTitle:@"选择你的视频" handler:^{
            if ( librarySelected ) {
                librarySelected(viewController);
            }
        }];
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [actionSheet bk_addButtonWithTitle:@"录制视频" handler:^{
                if ( cameraSelected ){
                    cameraSelected(viewController);
                }
            }];
        }
        
        [actionSheet bk_setCancelButtonWithTitle:@"取消" handler:nil];
        
        [actionSheet showInView:viewController.view];
    }
}


@end
