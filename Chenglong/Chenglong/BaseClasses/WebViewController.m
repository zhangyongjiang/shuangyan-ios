#import "WebViewController.h"
#import "SVProgressHUD.h"

@interface WebViewController () <UIWebViewDelegate>
{
    NSString *_url;
    NSString *_html;
    NSString *_file;
    UIWebView *webView;
    NSString* _title;
}
@end

@implementation WebViewController

-(id)initWithHtml:(NSString *)html andTitle:(NSString *)title {
    self = [super init];
    if (self) {
        _html = html;
        _title = title;
    }
    return self;
}

-(id)initWithFile:(NSString *)file andTitle:(NSString *)title {
    self = [super init];
    if (self) {
        _file = file;
        _title = title;
    }
    return self;
}

- (id)initWithUrl:(NSString *)url andTitle:(NSString*)title
{
    self = [super init];
    if (self) {
        if ([url hasPrefix:@"http"]) {
            _url = url;
        }
        else if ([url hasPrefix:@"/"]){
            _url = [NSString stringWithFormat:@"%@%@", [WebService baseUrl], url];
        }
        else {
            _url = [NSString stringWithFormat:@"%@/%@", [WebService baseUrl], url];
        }
        _title = title;
    }
    return self;
}

-(void)createPage {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64) ];
    webView.scalesPageToFit = YES;
    webView.delegate = self;
    
    [self.view addSubview:webView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = _title;
    [self setup];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) setup
{
    [webView setAllowsInlineMediaPlayback:YES];
    [webView setMediaPlaybackRequiresUserAction:NO];
    if (_url) {
        [SVProgressHUD show];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    }
    if(_html) {
        [webView loadHTMLString:_html baseURL:nil];
    }
    if(_file) {
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:_file]]];
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (_url) {
        [SVProgressHUD popActivity];
    }
    NSLog(@"webViewDidFinishLoad %@", webView.request.URL);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webViewDidStartLoad %@", webView.request.URL);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Error : %@",error);
    [webView loadHTMLString:error.description baseURL:[[NSBundle mainBundle] resourceURL]];

}

-(void)viewWillDisappear:(BOOL)animated {
    [webView stopLoading];
}

@end
