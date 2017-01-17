//
//  UIImagePickerController+Kaishi.h
//  Kaishi
//
//  Created by Hyun Cho on 2/2/16.
//  Copyright © 2016 BCGDV. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PickerOptionSelected)(UIViewController*);

@interface UIImagePickerController (Kaishi)

+ (void)showImagePickerOptionsFromViewController:(UIViewController*)viewController cameraSelected:(PickerOptionSelected)cameraSelected withLibrarySelected:(PickerOptionSelected)librarySelected;
+ (void)showVideoPickerOptionsFromViewController:(UIViewController*)viewController cameraSelected:(PickerOptionSelected)cameraSelected withLibrarySelected:(PickerOptionSelected)librarySelected;

@end
