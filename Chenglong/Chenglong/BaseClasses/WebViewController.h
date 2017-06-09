#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface WebViewController : BaseViewController

-(id)initWithUrl:(NSString *)url andTitle:(NSString*)title;
-(id)initWithFile:(NSString *)file andTitle:(NSString*)title;
-(id)initWithHtml:(NSString *)html andTitle:(NSString*)title;

@end
