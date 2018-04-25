//
//  GLD_UserProtocolController.m
//  lingzhi
//
//  Created by yiyangkeji on 2018/4/25.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_UserProtocolController.h"

@import WebKit;
@interface GLD_UserProtocolController ()
@property (nonatomic, strong)WKWebView *webView;
@end

@implementation GLD_UserProtocolController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    self.title = @"用户协议";
    self.webView.frame = self.view.bounds;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loadWebContent:(WKWebView *)webview{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"protocol" ofType:@"html"];
    NSString *htmlStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //    NSString *basePath = [[NSBundle mainBundle]bundlePath];
    //
    //    NSURL *baseUrl = [NSURL fileURLWithPath:basePath];
    
    [webview loadHTMLString:htmlStr baseURL:nil];
}
- (WKWebView *)webView{
    if (_webView == nil) {
        WKWebView *webView = [[WKWebView alloc]init];
        [self loadWebContent:webView];
        webView.navigationDelegate = self;
        _webView = webView;
    }
    return _webView;
}
// WKNavigationDelegate 页面加载完成之后调用
//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
//    //修改字体大小 150%
//    [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '300%'" completionHandler:nil];
//    
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
