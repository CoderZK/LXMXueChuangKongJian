//
//  LxmWebViewController.m
//  zhima
//
//  Created by lxm on 14/11/19.
//  Copyright (c) 2014年 lxm. All rights reserved.
//

#import "LxmWebViewController.h"
#import <WebKit/WebKit.h>
@interface LxmWebViewController ()<WKNavigationDelegate,UIWebViewDelegate>
{
    UIWebView *_webView;
    
    UIProgressView * _progress;
    WKWebView * _wkWebView;
    UIActivityIndicatorView * _activityView;
    
    NSString * _htmlStr;
    NSString * _urlStr;
}
@end

@implementation LxmWebViewController
-(void)loadHtmlStr:(NSString *)htmlStr withBaseUrl:(NSString *)urlStr
{
    _htmlStr = htmlStr;
    _urlStr = urlStr;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [self.navigationController setNavigationBarHidden:NO animated:animated];
    if (_progress)
    {
        [self.navigationController.navigationBar addSubview:_progress];
        [_wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_progress)
    {
        [_progress removeFromSuperview];
        [_wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    }
   
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"])
    {
        CGFloat progress = [[change objectForKey:@"new"] doubleValue];
        [_progress setProgress:progress animated:YES];
        _progress.hidden=(progress>=1);
        if (progress>=1)
        {
            _progress.progress=0;
        }
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 0.5)];
    line.backgroundColor = LineColor;
    [self.view addSubview:line];
    
    _wkWebView=[[WKWebView alloc] initWithFrame:CGRectMake(0, 0.5, self.view.bounds.size.width, self.view.bounds.size.height - StateBarH - 44)];
    _wkWebView.allowsBackForwardNavigationGestures=YES;
    _wkWebView.navigationDelegate=self;
    [self.view addSubview:_wkWebView];
    
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(self.view);
    }];
    
    _progress=[[UIProgressView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height-1.5, self.view.bounds.size.width, 1.5)];
    _progress.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
    //修改进度条颜色
    _progress.progressTintColor=RedColor;
    if (_loadUrl)
    {
        if (_postParames)
        {
            NSMutableURLRequest * req = [NSMutableURLRequest requestWithURL:_loadUrl];
            [req setHTTPMethod:@"POST"];
            [req setHTTPBody:[_postParames dataUsingEncoding:NSUTF8StringEncoding]];
            [_wkWebView loadRequest:req];
        }
        else
        {
            [_wkWebView loadRequest:[NSURLRequest requestWithURL:_loadUrl]];
        }
    }
    else if (_htmlStr)
    {
        [_wkWebView loadHTMLString:_htmlStr baseURL:[NSURL URLWithString:_urlStr]];
    }
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    decisionHandler(WKNavigationResponsePolicyAllow);
}
#pragma mark UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    _activityView.hidden=NO;
    [_activityView startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _activityView.hidden=YES;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    _activityView.hidden=YES;
}
@end
