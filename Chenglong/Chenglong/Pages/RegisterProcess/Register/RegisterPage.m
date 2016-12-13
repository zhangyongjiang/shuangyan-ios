#import "RegisterPage.h"

@interface RegisterPage()


@end

@implementation RegisterPage

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    self.phoneField = [[FullWidthField alloc] initWithPlaceHolder:@"电话号码"];
    [self addSubview:self.phoneField];
    
    self.codeField = [[FullWidthField alloc] initWithPlaceHolder:@"验证码"];
    [self addSubview:self.phoneField];
    
    self.passwordField = [[FullWidthField alloc] initWithPlaceHolder:@"密码"];
    [self addSubview:self.phoneField];
    
    self.nicknameField = [[FullWidthField alloc] initWithPlaceHolder:@"昵称"];
    [self addSubview:self.phoneField];
    
    self.submitBtn = [self createActionButton:@"立即注册" image:nil bgcolr:nil];
    
    return self;
}

-(void)layoutSubviews {
    self.phoneField.y = 100;
}

@end
