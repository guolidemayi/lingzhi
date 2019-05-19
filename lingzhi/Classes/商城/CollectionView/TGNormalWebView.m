//
//  TGNormalWebView.m
//  xiyouji
//
//  Created by westrip on 2018/4/28.
//  Copyright © 2018年 Westrip. All rights reserved.
//

#import "TGNormalWebView.h"
#import "UIBarButtonItem+Extension.h"
#import <WebKit/WebKit.h>
//状态条高度
#define STATUSBAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height

//导航条高度
#define GLD_NAVBAR_HEIGHT 44.0
#define SYSTEMTOP_HEIGHT (STATUSBAR_HEIGHT + GLD_NAVBAR_HEIGHT)
@interface TGNormalWebView ()<WKNavigationDelegate,WKUIDelegate>

@property (nonatomic,strong) WKUserContentController   *userContentController;

@property (nonatomic, strong) UIProgressView           *progressView;

@property (nonatomic, strong) WKWebView                *webViewWK;

@end

@implementation TGNormalWebView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = self.titleString;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    [self leftItemByType];
    [self setUpUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
}
- (void)setUpUI {
    self.userContentController =[[WKUserContentController alloc]init];
    
    WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];
    configuration.userContentController = self.userContentController;
    configuration.preferences.javaScriptEnabled = YES;
    
    self.webViewWK = [[WKWebView alloc]initWithFrame:CGRectMake(0, SYSTEMTOP_HEIGHT, DEVICE_WIDTH, DEVICE_HEIGHT - SYSTEMTOP_HEIGHT) configuration:configuration];
    
    if (@available(iOS 11.0, *)) {
        self.webViewWK.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    [self.view addSubview:self.webViewWK];
    self.webViewWK.navigationDelegate = self;
    self.webViewWK.UIDelegate = self;
    //加载url
    [self loadWebview];
    
    [self makeProgressView];
}

//创建进度条
-(void)makeProgressView
{
    [self.webViewWK addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, SYSTEMTOP_HEIGHT, CGRectGetWidth(self.view.frame),2)];
    [self.view addSubview:self.progressView];
}

#pragma mark - KVO代理方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if ([keyPath isEqual: @"estimatedProgress"] && object == self.webViewWK) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:self.webViewWK.estimatedProgress animated:YES];
        if(self.webViewWK.estimatedProgress >= 1.0f)
        {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

//封装load方法
-(void)loadWebview{
    //加载菊花
    
    [self.webViewWK loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
}

//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"开始加载h5  ==> %@",webView.URL);
    NSLog(@"开始加载h5 userAgent ==> %@",[[NSUserDefaults standardUserDefaults] stringForKey:@"UserAgent"]);

}
// 页面加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"H5加载完成");
}
// 页面加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"网络异常");
}

- (void)dealloc {
    //移除观察者
    if (self.progressView) {
        [self.webViewWK removeObserver:self forKeyPath:@"estimatedProgress"];
    }
}

- (void)leftItemByType {
    //返回按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonLeftBackTarget:self selector:@selector(backClick) blackArrow:YES];
}

- (void)backClick {
    if ([self.webViewWK canGoBack]) {
        [self.webViewWK goBack];
    } else{
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
