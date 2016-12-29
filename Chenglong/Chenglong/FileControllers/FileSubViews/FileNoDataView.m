//
//  FileNoDataView.m
//  Chenglong
//
//  Created by wangyaochang on 2016/12/29.
//  Copyright © 2016年 Chenglong. All rights reserved.
//

#import "FileNoDataView.h"

@interface FileNoDataView ()

@property (weak, nonatomic) IBOutlet UIButton *btnFolder;
@property (weak, nonatomic) IBOutlet UIButton *btnFile;

@end

@implementation FileNoDataView

- (void)awakeFromNib
{
    [super awakeFromNib];
    _btnFolder.layer.borderColor = [UIColor kaishiColor:UIColorTypeThemeSelected].CGColor;
    _btnFolder.layer.borderWidth = .5f;
    
}

@end
