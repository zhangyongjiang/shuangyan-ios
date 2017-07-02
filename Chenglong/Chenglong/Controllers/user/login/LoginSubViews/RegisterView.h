//
//  RegisterView.h
//  Chenglong
//
//  Created by wangyaochang on 2016/12/27.
//  Copyright © 2016年 Chenglong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterView : UIView

@property (weak, nonatomic) IBOutlet UITextField *tfPhone;
@property (weak, nonatomic) IBOutlet UITextField *tfCode;
@property (weak, nonatomic) IBOutlet UITextField *tfPwd;
@property (weak, nonatomic) IBOutlet UITextField *tfNickName;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *lbRemind;
@property (weak, nonatomic) IBOutlet UIButton *btnSendCode;

@end
