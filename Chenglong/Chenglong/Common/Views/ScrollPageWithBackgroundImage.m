#import "ScrollPageWithBackgroundImage.h"

@interface ScrollPageWithBackgroundImage()

@property(strong, nonatomic) UIImageView* bgImgView;

@end

@implementation ScrollPageWithBackgroundImage

-(id)initWithFrame:(CGRect)frame andImage:(NSString *)imgName {
    self = [super initWithFrame:frame];
    self.imgOffset = -64;
    
    UIImage* img = [UIImage imageNamed:imgName];
    CGFloat width = frame.size.width;
    CGFloat height = width * img.size.height / img.size.width;
    self.bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.imgOffset, width, height)];
    self.bgImgView.image = img;
    
    self.scrollView.contentSize = CGSizeMake(width, height);
    [self.scrollView addSubview:self.bgImgView];
    
    return self;
}

@end
