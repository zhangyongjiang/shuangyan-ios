#import "FormPage.h"

@interface RegisterPage : FormPage

@property(strong, nonatomic)FullWidthField* phoneField;
@property(strong, nonatomic)FullWidthField* codeField;
@property(strong, nonatomic)FullWidthField* passwordField;
@property(strong, nonatomic)FullWidthField* nicknameField;
@property(strong, nonatomic)FullWidthField* genderField;
@property(strong, nonatomic)FullWidthField* provinceField;
@property(strong, nonatomic)FullWidthField* cityField;

@property(strong,nonatomic)UIButton* submitBtn;

@end
