//
//  FKWebViewController.h
//  Kaishi
//
//  Created by jijunyuan on 16/7/11.
//  Copyright © 2016年 xinkaishi－jjy. All rights reserved.
//

#import "KSWebViewController.h"
//#import <JavaScriptCore/JavaScriptCore.h>
//#import "UIWebView+TS_JavaScriptContext.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"

@interface KSWebViewController ()<UIWebViewDelegate,NJKWebViewProgressDelegate,UIGestureRecognizerDelegate>
{
    NJKWebViewProgress *_progressProxy;
}
@property (strong, nonatomic) UIWebView  *webView;
@property (nonatomic, strong) NJKWebViewProgressView *progressView;
//@property (nonatomic,strong) JSContext *context ;
@property (nonatomic, strong) UIBarButtonItem *closeButtonItem;
@property (nonatomic, strong) UIBarButtonItem *backButtonItem;
@property (nonatomic, strong) UIBarButtonItem *shareButtonItem;
@property (nonatomic, weak) id <UIGestureRecognizerDelegate> popDelegate;
@end

@implementation KSWebViewController

+ (instancetype)spawn
{
    return [KSWebViewController new];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.navigationController.viewControllers.count > 1) {
        // 记录系统返回手势的代理
        _popDelegate = self.navigationController.interactivePopGestureRecognizer.delegate;
        // 设置系统返回手势的代理为当前控制器
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
    [self.navigationController.navigationBar addSubview:self.progressView];
    WeakSelf(weakSelf)
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.progressView.alpha = 1.f;
    }];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.progressView removeFromSuperview];
    // 设置系统返回手势的代理为我们刚进入控制器的时候记录的系统的返回手势代理
    self.navigationController.interactivePopGestureRecognizer.delegate = _popDelegate;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navBgView.backgroundColor = [UIColor colorFromString:@"f6f6f6"];
    self.view.backgroundColor = [UIColor kaishiColor:UIColorTypeBackgroundColor];
    [self.view addSubview:self.webView];
    
    //加载数据
    [self configEcoM];
    //初始化items
    [self configNavBarItems];
    
    if (self.navTitle)
    {
        self.title = self.navTitle;
    }
    if (!self.isHiddenShare)
    {
        self.navigationItem.rightBarButtonItem = self.shareButtonItem;
    }
    [self.view setNeedsUpdateConstraints];
}

#pragma mark -- 配置M站
- (void)configEcoM
{
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    
    [self.webView loadRequest:request];
}

#pragma mark -- 配置导航按钮
- (void)configNavBarItems
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"xinkaishi_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStylePlain target:self action:@selector(backEvent:)];
    [backButton setImageInsets:UIEdgeInsetsMake(0, -8, 0, 8)];
    self.backButtonItem = backButton;
    
    self.navigationItem.leftBarButtonItems = @[self.backButtonItem];
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"bar_close_icon_line"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(closeEvent:)];
    [closeButton setImageInsets:UIEdgeInsetsMake(0, -30, 0, 30)];
    self.closeButtonItem = closeButton;
    
//     self.shareButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"sharebutton"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStylePlain target:self action:@selector(shareAction)];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    [_webView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer
{
    return YES;
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    if ( [NSString isEmpty:self.navTitle] )
    {
        self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        self.navigationItem.rightBarButtonItem = self.isHiddenShare ? nil : self.shareButtonItem;
    }
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if ( [NSString isEmpty:self.navTitle] )
    {
        self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
}


//#pragma mark -----  js 与 webview 交互
//- (void)webView:(UIWebView *)webView didCreateJavaScriptContext:(JSContext *)ctx
//{
//    ctx[@"jump"] = ^(NSString *name ,NSString *argumnet, NSString *other) {
//        if ([name isEqualToString:@"feedback"]) {
//            dispatch_async( dispatch_get_main_queue(), ^{
//                HelpViewController *help = [HelpViewController loadFromStoryBoard:@"HelpViewController"];
//                [self.navigationController pushViewController:help animated:YES];
//            });            
//        }
//    };
//    ctx[@"viewController"] = self;
//}

//使用的时候 重写此方法
-(void)backEvent:(UIBarButtonItem *)item
{
    if ([self.webView canGoBack])
    {
        self.navigationItem.leftBarButtonItems = @[self.backButtonItem,self.closeButtonItem];
        [self.webView goBack];
        return;
    }
    
    [self closeEvent:nil];
}

- (void)closeEvent:(UIBarButtonItem *)item
{
    if (self.closeBlock)
    {
        self.closeBlock();
    }
    if (self.isPush)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

- (NJKWebViewProgressView *)progressView
{
    if (_progressView == nil)
    {
        _progressProxy = [[NJKWebViewProgress alloc] init];
        self.webView.delegate = _progressProxy;
        _progressProxy.webViewProxyDelegate = self;
        _progressProxy.progressDelegate = self;
        
        CGFloat progressBarHeight = 2.f;
        CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
        CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
        _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        _progressView.alpha = 0.f;
    }
    return _progressView;
}

- (UIWebView *)webView
{
    if (_webView == nil)
    {
        _webView = [[UIWebView alloc] init];
        _webView.backgroundColor = [UIColor clearColor];
        [_webView setScalesPageToFit:YES];
        _webView.delegate = self;
    }
    return _webView;
}


@end
