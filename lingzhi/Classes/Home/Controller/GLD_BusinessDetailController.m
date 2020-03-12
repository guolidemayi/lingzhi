//
//  GLD_BusinessDetailController.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/4.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_BusinessDetailController.h"
#import "GLD_BusnessModel.h"

#import "GLD_BusinessDetailManager.h"
#import "MapNavigationManager.h"
#import "GLD_PostController.h"

#import "GLD_BusnessCommentController.h"
#import "GLD_OldPayForBusnController.h"
#import "OCPublicEngine.h"

@import WebKit;
@interface GLD_BusinessDetailController ()<WKNavigationDelegate>

//@property (nonatomic, strong)UITableView *detail_table;
//@property (nonatomic, strong)GLD_BusinessDetailManager *busnessManager;
//@property (nonatomic, strong)UIView *bottomView;

@property (nonatomic, weak)UIButton *collectBut;
@property (nonatomic, assign)NSInteger isCollection;
@property (nonatomic, strong)WKWebView *webView;
//0 收藏  1 取消
@end

@implementation GLD_BusinessDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.busnessModel.name;
    
    
    [self layout];
    [self setRightBut];
    
    if (self.busnessModel) {
        NSString *url = [NSString stringWithFormat:@"%@%@&userId=%@",shopDetailUrl,self.busnessModel.userId,GetString([AppDelegate shareDelegate].userModel.userId)];
         [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        [self isCollectionRequest];
    }else{
        [self getShopDetailModel];
    }
    
}
- (void)layout{
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-iPhoneXTopHeight);
        make.left.right.top.equalTo(self.view);
    }];
}

- (void)initData{
    
}
- (void)getShopDetailModel{
    WS(weakSelf);
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
        config.requestType = gld_networkRequestTypePOST;
        config.urlPath = @"api/user/getMyShop";
        config.requestParameters = @{@"userId" : GetString(self.userId)};
        
        [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
            NSError *ee;
            weakSelf.busnessModel = [[GLD_BusnessModel alloc] initWithDictionary:result[@"data"] error:&ee];
        
            [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@&userId=%@",shopDetailUrl,weakSelf.busnessModel.userId,GetString([AppDelegate shareDelegate].userModel.userId)]]]];

        }];
}
- (void)setRightBut{
    UIButton *rightBut = [[UIButton alloc]init];;
    self.collectBut = rightBut;
    rightBut.frame = CGRectMake(0, 0, 30, 44);
    [rightBut setImage:WTImage(@"btn_shoucang_null") forState:UIControlStateNormal];
    [rightBut addTarget:self action:@selector(collectionClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:rightBut];
    
    UIButton *shareBut = [[UIButton alloc]init];;
    shareBut.frame = CGRectMake(0, 0, 30, 44);
       [shareBut setImage:WTImage(@"分享icon") forState:UIControlStateNormal];
       [shareBut addTarget:self action:@selector(shareButClick) forControlEvents:UIControlEventTouchUpInside];
       UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:shareBut];
    
    self.navigationItem.rightBarButtonItems = @[item2,item1];
    
    UIButton *backBut = [[UIButton alloc]init];;
       backBut.frame = CGRectMake(0, 0, 30, 44);
          [backBut setImage:WTImage(@"header_back_icon") forState:UIControlStateNormal];
          [backBut addTarget:self action:@selector(backButClick) forControlEvents:UIControlEventTouchUpInside];
          UIBarButtonItem *item3 = [[UIBarButtonItem alloc]initWithCustomView:backBut];
    self.navigationItem.leftBarButtonItem = item3;
}
- (void)backButClick{
//    if ([self.webView canGoBack]) {
//        [self.webView goBack];
//    }else{
//    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)shareButClick{
    NSString *url = [NSString stringWithFormat:@"%@%@",shopDetailUrl,self.busnessModel.userId];
    NSString *imageStr = @"";
    if([self.busnessModel.logo containsString:@","]){
           NSArray *arr = [self.busnessModel.logo componentsSeparatedByString:@","];
        imageStr = arr.firstObject;
       }else{
           imageStr = self.busnessModel.logo;
       }
    [OCPublicEngine showShareViewWithType:KShareViewTypePerson withDelegate:self shareText:self.busnessModel.name shareUrl:url shareDetail:self.busnessModel.desc shareImage:imageStr shareTitle:self.busnessModel.name];
}
- (void)isCollectionRequest{
    WS(weakSelf);
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/main/isCollect";
    config.requestParameters = @{
                                 @"dataId":GetString(self.busnessModel.industryId),
                                 @"userId":GetString([AppDelegate shareDelegate].userModel.userId),
                                 };
    
    
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        if(error){
            
            
        }else{
            weakSelf.isCollection = [result[@"data"] integerValue];
            if(weakSelf.isCollection != 0){
                [weakSelf.collectBut setImage:WTImage(@"课程页-已收藏") forState:UIControlStateNormal];
            }
            
        }
        
    }];
}

- (void)collectionClick{
    WS(weakSelf);
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/main/collectionShop";
    config.requestParameters = @{
                                 @"dataId":GetString(self.busnessModel.industryId),
                                 @"userId":GetString([AppDelegate shareDelegate].userModel.userId),
                                 @"collectionType":[NSString stringWithFormat:@"%zd",self.isCollection]
                                 };
    
    
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        if(error){
            [CAToast showWithText:@"收藏失败，请稍后再试"];
            
        }else{
            weakSelf.busnessModel.isCollect = weakSelf.busnessModel.isCollect.integerValue == 1? @"0":self.busnessModel.isCollect;
            weakSelf.isCollection == 0 ? (weakSelf.isCollection = 1) : (weakSelf.isCollection = 0);
            if(weakSelf.isCollection != 0){
                [weakSelf.collectBut setImage:WTImage(@"课程页-已收藏") forState:UIControlStateNormal];
            }else{
                [weakSelf.collectBut setImage:WTImage(@"btn_shoucang_null") forState:UIControlStateNormal];
            }
            [CAToast showWithText:result[@"data"]];
            
        }
        
    }];
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{

    NSString *urlStr = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
//    WKNavigationActionPolicy policy = WKNavigationActionPolicyCancel;
    if ([urlStr containsString:@"navigate"]) {//导航
        //hhlm://wap/shop/navigate?latitude=125.3&longitude=106.7
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [self.busnessModel.xpoint floatValue];
        coordinate.longitude = [self.busnessModel.ypoint floatValue];
        [MapNavigationManager showSheetWithCoordinate2D:coordinate];
        
    }else if([urlStr containsString:@"comment"]){//评论
        //hhlm://wap/shop/comment?shopid=xxx

        GLD_BusnessCommentController *commentVc = [GLD_BusnessCommentController new];
        commentVc.busnessModel = self.busnessModel;
        [self.navigationController pushViewController:commentVc animated:YES];
        
    }else if([urlStr containsString:@"goods/add"]){//新增商品
        //hhlm://wap/goods/add?shopid=xxx

        GLD_PostController *postVC = [GLD_PostController instancePost:^{
            
        } andType:2];
        [self.navigationController pushViewController:postVC animated:YES];
        
        
    }else if([urlStr containsString:@"shop/pay"]){//支付
        //hhlm://wap/shop/pay?shopid=xxx
        if(!hasLogin){
            [CAToast showWithText:@"请登录"];
            return;
        }
        GLD_OldPayForBusnController *jumpVC = [[GLD_OldPayForBusnController alloc] init];
        //        jumpVC.jump_URL = result;
            jumpVC.payForUserId = self.busnessModel.userId;

        [self.navigationController pushViewController:jumpVC animated:YES];
        
        
    }else if([urlStr containsString:@"action/callphone"]){//打电话
        //hhlm://wap/action/callphone?phonenum=1212313
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[NSString stringWithFormat:@"tel://%@",self.busnessModel.cellphone] stringByReplacingOccurrencesOfString:@"-" withString:@""]]];
        
        
    }
    
    
    
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{

//    [self.webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
//    [self.webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';" completionHandler:nil];
  
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation;{
    
    
   
}
- (WKWebView *)webView{
    if (!_webView) {
        
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
        configuration.allowsInlineMediaPlayback = true;//关闭视频默认全屏
        WKWebView* webView = [[NSClassFromString(@"WKWebView") alloc] initWithFrame:CGRectZero configuration:configuration];
        webView.navigationDelegate = self;
        
        _webView = webView;
        _webView.scrollView.bounces = NO;
    
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
    }
    return _webView;
}
@end
