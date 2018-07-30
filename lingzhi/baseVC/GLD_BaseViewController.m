//
//  GLD_BaseViewController.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/11/23.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_BaseViewController.h"
#import "GLD_PayForBusinessController.h"

@interface GLD_BaseViewController ()

@end

@implementation GLD_BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.noDataLabel];
    [self.noDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    self.NetManager = [GLD_NetworkAPIManager new];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reciveQRCodePayAction:) name:RECIV_EQRCODEPAY_ACTION object:nil];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RECIV_EQRCODEPAY_ACTION object:nil];
}
- (void)reciveQRCodePayAction:(NSNotification *)noti{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:NSClassFromString(@"GLD_PayForBusinessController")]) {
            return;
        }
    }
    NSString *str =noti.object;
    NSArray *arr = [str componentsSeparatedByString:@"/"];
    GLD_PayForBusinessController *jumpVC = [[GLD_PayForBusinessController alloc] init];
    //        jumpVC.jump_URL = result;
    if (IsExist_Array(arr))
        jumpVC.payForUserId = arr.lastObject;
    
    [self.navigationController pushViewController:jumpVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)outLayoutSelfSubviews
{
    for (UIView *views in self.view.subviews) {
        views.frame = WTCGRectMake(views.frame);
        
        if ([views isKindOfClass:[UIWebView class]]) {
            continue;
        }
        if ([views isKindOfClass:[UIButton class]]) {
            continue;
        }
        if ([views isKindOfClass:[UISearchBar class]]){
            continue;
        }
        for (UIView *subViews in views.subviews) {
            subViews.frame = WTCGRectMake(subViews.frame);
        }
    }
}
- (UILabel *)noDataLabel{
    if (!_noDataLabel) {
        _noDataLabel = [UILabel creatLableWithText:@"暂时无相关门店信息 T_T" andFont:WTFont(15) textAlignment:NSTextAlignmentCenter textColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTline2Gray]];
        _noDataLabel.hidden = YES;
    }
    return _noDataLabel;
}
@end
