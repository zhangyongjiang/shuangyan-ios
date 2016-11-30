#import "ScrollPage.h"

@interface ScrollPageWithBackgroundImage : ScrollPage

@property(assign, nonatomic) CGFloat imgOffset;

-(id) initWithFrame:(CGRect)frame andImage:(NSString*)imgName;

@end
