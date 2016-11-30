#import "SplashPage.h"

@interface SplashPage()


@end

@implementation SplashPage

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    UIImageView* view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bb-logo.png"]];
    view.y = 100;
    [self addSubview:view];
    [view hcenterInParent];
    
    {
        UIImage* img = [UIImage imageNamed:@"szj.png"];
        CGFloat w = [UIView screenWidth]*0.8;
        UIImageView* view1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 300, w, w * img.size.height/img.size.width)];
        view1.image = img;
        view1.y = 300;
        [self addSubview:view1];
        [view1 hcenterInParent];
    }
    
    return self;
}

@end
