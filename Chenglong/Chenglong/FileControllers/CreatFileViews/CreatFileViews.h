//
//  CreatFileViews.h
//  Chenglong
//
//  Created by wangyaochang on 2017/1/16.
//  Copyright © 2017年 Chenglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreatFileTypeView.h"
#import "TZImagePickerController.h"
#import "MediaAttachment.h"
#import "DVFullScreenMediaViewer.h"
#import "MediaAttachmentDataSource.h"

@interface CreatFileViews : UIView

@property (nonatomic, strong) UITextField *tfTitle;
@property (nonatomic, strong) UIPlaceHolderTextView *tvContent;
@property (nonatomic, strong) CreatFileTypeView *chooseTypeView;

@property (nonatomic, assign) FileMediaType mediaType;

@property (nonatomic, strong) MediaAttachmentDataSource *mediaAttachmentDataSource;
@property (nonatomic, strong) TZImagePickerController *imagePicker;
@property (nonatomic, strong) UIImagePickerController *mediaPicker;
@property (nonatomic, strong) DVFullScreenMediaViewer *fullScreen;
@end
