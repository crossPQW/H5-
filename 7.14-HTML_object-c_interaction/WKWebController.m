//
//  WKWebController.m
//  7.14-HTML_object-c_interaction
//
//  Created by 黄少华 on 15/7/28.
//  Copyright (c) 2015年 NXAristotle. All rights reserved.
//

#import "WKWebController.h"

#import <WebKit/WebKit.h>
@interface WKWebController ()<WKNavigationDelegate,WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;
@end

@implementation WKWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.webView = webView;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
    [self.view addSubview:webView];
    
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"start-test.html" ofType:nil];
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    [webView loadHTMLString:html baseURL:[NSURL URLWithString:path]];
}




- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"didStart");
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"%s",__func__);
}

@end
