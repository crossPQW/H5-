//
//  NXInfoViewController.m
//  7.14-HTML_object-c_interaction
//
//  Created by linyibin on 15/7/14.
//  Copyright (c) 2015年 NXAristotle. All rights reserved.
//

#import "NXInfoViewController.h"
#import "PerformSelector.h"
#import <WebKit/WebKit.h>
#import "ViewController.h"
#import "CALayer+Transition.h"
#import "UIView+Genie.h"
#define kScreenW  [UIScreen mainScreen].bounds.size.width
#define kScreenH  [UIScreen mainScreen].bounds.size.height


#define kCustomProtocol @"ocfunc://"

@interface NXInfoViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation NXInfoViewController


- (void)loadView
{
    // 在实例化self.view之前，不能有任何调用self.view的操作，否则会死循环
    self.webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.webView.delegate = self;
    self.view = self.webView;
    
    NSLog(@"%@", self.view);
}


- (void)btnClick:(UIButton *)btn
{
    
    [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor whiteColor];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGRect endRect = CGRectMake(width - 32, 42, 1, 1);
   [self.view genieInTransitionWithDuration:0.8f destinationRect:endRect destinationEdge:BCRectEdgeBottom completion:^{
        NSLog(@"complete");
       [self.navigationController popViewControllerAnimated:NO];
    }];
    
//        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//        UIView *snapView = [keyWindow snapshotViewAfterScreenUpdates:NO];
//        [keyWindow addSubview:snapView];
//
//        dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue(), ^{
//            [snapView genieInTransitionWithDuration:0.5f destinationRect:endRect destinationEdge:BCRectEdgeBottom completion:^{
//                NSLog(@"哈哈");
//                
//            }];
//        }) ;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.rightBarButtonItem = item;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"start-test.html" ofType:nil];
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    [self.webView loadHTMLString:html baseURL:[NSURL URLWithString:path]];
    
//    // js注入，让OC去操作页面
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
//    
//    btn.center = CGPointMake(kScreenW * 0.5, kScreenH * 0.5);
//    [self.view addSubview:btn];
//    
//    [btn addTarget:self action:@selector(callJSFunc) forControlEvents:UIControlEventTouchUpInside];

}




#pragma mark - JS注入的方法
- (void)callJSFunc
{
    NSLog(@"%s", __func__);
    // 在本地的html的head中添加一段javascript
    NSString *js = @"var script = document.createElement('script');"
    "script.type = 'text/javascript';"
    "script.text = \"function myFunction() { "
    "var field = document.getElementsByName('word')[0];"
    "field.value='iPhone';"
    "document.forms[0].submit();"
    "}\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    
    // 执行js，能够将js注入到本地的html中
    [self.webView stringByEvaluatingJavaScriptFromString:js];
    
    // 执行注入js中自定义的方法
    [self.webView stringByEvaluatingJavaScriptFromString:@"myFunction();"];
}

/**
 *  显示消息
 *
 *  @param msg 消息的内容
 */
- (void)showMessage:(NSString *)msg
{
    // 取消百分号转义，以便能够显示中文
    msg = [msg stringByRemovingPercentEncoding];
    
    [[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
}

- (void)goBack:(NSString *)msg {
    // 取消百分号转义，以便能够显示中文
    msg = [msg stringByRemovingPercentEncoding];
    
    NSLog(@"msg:%@",msg);
    
 
    [self.view.window.layer transitionWithAnimType:TransitionAnimTypeSuckEffect subType:TransitionSubtypesFromLeft curve:TransitionCurveDefault duration:2.f];

    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)goBack
{
    NSLog(@"goBack");
}


#pragma mark - webView代理方法
/**
 shouldStartLoadWithRequest 将要开始加载请求
 navigationType 浏览的类型(在当前窗口打开，还是在新窗口打开)
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // url的absoluteString表示url完整的字符串
    NSLog(@"%@", request.URL.absoluteString);
    
    NSString *urlStr = request.URL.absoluteString;
    // 如果是ocfunc://开头的，表示自定义协议，可以自定义操作
    if ([urlStr hasPrefix:kCustomProtocol]) {
        NSLog(@"自定义协议");
        
        // 去掉协议头
        NSString *content = [urlStr substringFromIndex:[kCustomProtocol length]];
        NSLog(@"%@", content);
        
        // 拆分字符串
        NSArray *array = [content componentsSeparatedByString:@"/"];
        NSLog(@"%@", array);
        
        // 拆分完的字符串，需要两个组成部分：方法名 | 参数
        // -- 增补 --
        if (array.count != 2) return NO;
        
        // 生成方法名字符串
        NSString *funcName = [NSString stringWithFormat:@"%@:", array[0]];
        NSLog(@"%@ - %@", funcName, array[1]);
        
        // 把字符串转换成方法 SEL
        SEL func = NSSelectorFromString(funcName);
        
        performSelectorWith(func, array[1])
        
        return NO;
    }
    return YES;
}

/**
 - (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script;
 
 是webView唯一和网页进行交互的方法
 */
// 需要把“网页加载完成”之后再进行交互
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 1> 直接调用javascript
    // 参数就是javascript
    // 返回值是javascript执行后的结果
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    NSLog(@"title ==> %@", title);
    
    // 2. 调用自定义的javascript的函数
//        [webView stringByEvaluatingJavaScriptFromString:@"clickme();"];
}



@end
