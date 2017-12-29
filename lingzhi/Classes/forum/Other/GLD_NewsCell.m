//
//  GLD_NewsCell.m
//  yxvzb
//
//  Created by yiyangkeji on 17/2/6.
//  Copyright © 2017年 sendiyang. All rights reserved.
//

#import "GLD_NewsCell.h"


@import WebKit;

@interface GLD_NewsCell ()<UIWebViewDelegate>{
    CGFloat cellHeight;
}


@property (nonatomic, strong)UIWebView *webView;

@end

@implementation GLD_NewsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupUI];
        
    }
    return self;
}

- (void)setupUI{
    UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 10)];
    self.webView = web;
    web.scrollView.scrollEnabled = NO;
    [self.contentView addSubview:web];
    web.delegate = self;
    [self.webView sizeToFit];

    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew  context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSizeNotification:) name:@"gldadjustWebSize" object:nil];
}


- (void)changeSizeNotification:(NSNotification *)noti{
    NSInteger type = [noti.object integerValue];
    [self adjustSizeWithWeb:type];

}

- (void)adjustSizeWithWeb:(NSInteger)type{
    
    NSString *keySize;
    switch (type) {
        case 1:
            
            keySize = @"jsChangeSize(1)";
            break;
        case 2:
            keySize = @"jsChangeSize(2)";
            break;
        case 3:
            keySize = @"jsChangeSize(3)";
            break;
            
    }
    [_webView stringByEvaluatingJavaScriptFromString:keySize];
    
    
    NSString * clientheight_str = [_webView stringByEvaluatingJavaScriptFromString: @"document.body.clientHeight"];
    float clientheight = [clientheight_str floatValue];
    self.webView.frame = CGRectMake(0, 0, DEVICE_WIDTH, clientheight);
    NSLog(@"改编后的感度 %f\n--",clientheight);
    
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{

  
    
    NSString * clientheight_str = [_webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
    if (cellHeight != [clientheight_str floatValue]) {
        cellHeight = [clientheight_str floatValue];
        self.webView.frame = CGRectMake(0, 0, DEVICE_WIDTH, cellHeight);
        
        NSLog(@"网页的高度-------->%f",cellHeight);
        if ([self.delegate respondsToSelector:@selector(refreshCellHeight:)]) {
            [self.delegate refreshCellHeight:cellHeight];
        }
    }
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if ([request.URL.absoluteString containsString:@"course?"]) {

        NSArray *arr = [request.URL.absoluteString componentsSeparatedByString:@"="];
        if ([self.delegate respondsToSelector:@selector(pushToViewControllor:)]) {
            [self.delegate pushToViewControllor:arr.lastObject];
        }
        return NO;
    }
    if (_contentString) {
        return YES;
    }
  
    return YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentSize"]) {
        

        NSString * clientheight_str = [_webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
        cellHeight = [clientheight_str floatValue];

        self.webView.frame = CGRectMake(0, 0, DEVICE_WIDTH, cellHeight);
        
        NSLog(@"网页的高度-------->%f",cellHeight);
        //            NSLog(@"\n%f",self.webView.scrollView.contentSize.height);
        if ([self.delegate respondsToSelector:@selector(refreshCellHeight:)]) {
            [self.delegate refreshCellHeight:cellHeight];
        }
    }
    
}

- (void)setForumDetailUrl:(NSString *)forumDetailUrl{
    _forumDetailUrl = forumDetailUrl;
    cellHeight = 0;
    _contentString = nil;
    if (forumDetailUrl)
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:forumDetailUrl]]];
}

- (void)setContentString:(NSString *)contentString{
    _contentString = nil;
    cellHeight = 0;
    self.forumDetailUrl = nil;
    _contentString = contentString;
    
//    if (cellHeight > 200) {
//        return;
//    }
//    if([contentString containsString:@"//cdn.yxvzb.com"]){
//        contentString = [contentString stringByReplacingOccurrencesOfString:@"//cdn.yxvzb.com" withString:@"http://cdn.yxvzb.com"];
//    }
    if (contentString)
//    [self.webView loadHTMLString:contentString baseURL:nil];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:contentString]]];
    
}


- (void)dealloc{
    
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"gldadjustWebSize" object:nil];
    NSLog(@"newsCell死了\n------------------------------------------------------");
}
@end
