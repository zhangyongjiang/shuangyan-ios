#import "ScrollPage.h"

@interface ScrollPage()

@end

@implementation ScrollPage

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
    [self addSubview:self.scrollView];
    
    return self;
}
@end
