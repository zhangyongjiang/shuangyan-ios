#import "RegisterPage.h"

@interface RegisterPage()

@property(strong, nonatomic)FullWidthField* phoneField;
@property(strong, nonatomic)FullWidthField* codeField;
@property(strong, nonatomic)FullWidthField* passwordField;

@end

@implementation RegisterPage

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

@end
