//
//  GLD_BBSStandardView.m
//  yxvzb
//
//  Created by yiyangkeji on 2017/6/12.
//  Copyright © 2017年 sendiyang. All rights reserved.
//

#import "GLD_BBSStandardView.h"

@import WebKit;
@interface GLD_BBSStandardView ()<WKNavigationDelegate>

@property (nonatomic, copy)bbsAgreetBlock bbsBlock;
@end

@implementation GLD_BBSStandardView

+ (void)showBBSStandardView:(bbsAgreetBlock)bbsblock{
    GLD_BBSStandardView *bbsView = [[GLD_BBSStandardView alloc]initWithFrame:[AppDelegate shareDelegate].window.bounds];
    bbsView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [[AppDelegate shareDelegate].window addSubview:bbsView];
    [bbsView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:bbsView action:@selector(tapClick)]];
    bbsView.userInteractionEnabled = YES;
    bbsView.bbsBlock = bbsblock;
    [bbsView setupUI];
    
}

- (void)tapClick{
    [self removeFromSuperview];

}
- (void)sureButClick{
    [self removeFromSuperview];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"bbsStandard"];
    self.bbsBlock ? self.bbsBlock() : nil;
}

- (void)loadWebContent:(WKWebView *)webview{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"bbs_edit_hint" ofType:@"html"];
    NSString *htmlStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    NSString *basePath = [[NSBundle mainBundle]bundlePath];
//    
//    NSURL *baseUrl = [NSURL fileURLWithPath:basePath];
    
    [webview loadHTMLString:htmlStr baseURL:nil];
}
- (void)setupUI{
    
    UIView *tipView = [[UIView alloc]init];
    tipView.backgroundColor = [UIColor whiteColor];
    [self addSubview:tipView];
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo([AppDelegate shareDelegate].window);
        make.width.equalTo(WIDTH(345));
        make.height.equalTo(HEIGHT(469));
    }];
    
    UILabel *titleLable = [UILabel creatLableWithText:@"论坛发帖规范" andFont:WTFont(17) textAlignment:NSTextAlignmentCenter textColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK]];
    [tipView addSubview:titleLable];
    [titleLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(tipView);
        make.top.equalTo(tipView).offset(H(12));
    }];
    
    
    UIView *lineView = [[UIView alloc]init];
    [tipView addSubview:lineView];
    lineView.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTline2Gray];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(tipView);
        make.top.equalTo(titleLable.mas_bottom).offset(H(15));
        make.width.equalTo(WIDTH(285));
        make.height.equalTo(HEIGHT(0.5));
    }];
    
    WKWebView *webView = [[WKWebView alloc]init];
    [self loadWebContent:webView];
    webView.navigationDelegate = self;
    [tipView addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(tipView);
        make.top.equalTo(lineView.mas_bottom).offset(H(15));
        make.width.equalTo(lineView);
        make.height.equalTo(HEIGHT(320));
    }];
    
    UIView *coverView = [[UIView alloc]init];
    [tipView addSubview:coverView];
    
    CAGradientLayer *colorLayer = [CAGradientLayer layer];
    
    colorLayer.frame = CGRectMake(0, 0, W(285), H(45));
    
    UIColor *colorOne = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.4];
    UIColor *colorTwo = [UIColor whiteColor];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:0.5];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    colorLayer.colors = colors;
    colorLayer.locations = locations;
    [coverView.layer insertSublayer:colorLayer above:0];
    
    [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(webView);
        make.centerX.equalTo(tipView);
        make.width.equalTo(lineView);
        make.height.equalTo(HEIGHT(45));
        
    }];
    
    UIButton  *sureBut = [[UIButton alloc]init];
    [sureBut addTarget:self action:@selector(sureButClick) forControlEvents:UIControlEventTouchUpInside];
    [sureBut setTitle:@"遵守规范，开始发帖" forState:UIControlStateNormal];
    [sureBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBut.titleLabel.font = WTFont(15);
    [sureBut setBackgroundImage:[UIImage imageNamed:@"nodata按钮"] forState:UIControlStateNormal];
    [tipView addSubview:sureBut];
    [sureBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(tipView).offset(H(-30));
        make.centerX.equalTo(tipView);
        make.width.equalTo(lineView);
        make.height.equalTo(HEIGHT(40));
        
    }];
    
    
}
// WKNavigationDelegate 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    //修改字体大小 150%
    [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '300%'" completionHandler:nil];
    
}
@end
