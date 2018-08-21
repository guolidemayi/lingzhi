//
//  GLD_GoodsDetailController.m
//  lingzhi
//
//  Created by yiyangkeji on 2018/7/30.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_GoodsDetailController.h"
#import "GLD_GoodsDetailManager.h"
#import "GLD_PayForBusinessController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "GLD_ExpressAddressView.h"

@interface GLD_GoodsDetailController ()<WXApiManagerDelegate>
@property (nonatomic, strong)GLD_GoodsDetailManager *goodsDetailManager;
@property (nonatomic, strong)UITableView *home_table;
@property (nonatomic, strong)UIButton *applyBut;
@property (nonatomic, assign) NSString *payType;
@property (nonatomic, strong)NSString *address;
@end

@implementation GLD_GoodsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.address = @"";
    [self setApplyBut];
    self.home_table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.home_table];
    [self.home_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.applyBut.mas_top);
    }];
    self.goodsDetailManager = [[GLD_GoodsDetailManager alloc]initWithTableView:self.home_table];
    self.goodsDetailManager.storeModel = self.storeModel;
    [self.goodsDetailManager fetchMainData];
    self.title = @"商品详情";
    [WXApiManager sharedManager].delegate = self;
}

- (void)setApplyBut{
    [self.view addSubview:self.applyBut];
    [self.applyBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self.view);
        make.height.equalTo(@(64));
    }];
}
- (void)applybutClick{
    
    [self showAddressView];
}

- (void)hasWriteAddress{
    switch (self.type) {
        case 1:
            [self payToScoreGoods];
            break;
        case 2:
            [self payToLowPriceGoods];
            break;
        case 3:
            [self showChoosePayTypeAlert];
            break;
    }
}
- (void)payToLowPriceGoods{
    GLD_PayForBusinessController *payVc = [GLD_PayForBusinessController new];
    payVc.payForUserId = self.storeModel.userId;
    payVc.payPrice = self.storeModel.price;
    payVc.address = self.address;
    [self.navigationController pushViewController:payVc animated:YES];
}
- (void)showChoosePayTypeAlert{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择支付方式" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    WS(weakSelf);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"支付宝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        weakSelf.payType = @"zfbPay";
        [weakSelf payToDaiJinQuanGoods];
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.payType = @"wxPay";
        [weakSelf payToDaiJinQuanGoods];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)payToDaiJinQuanGoods{
    WS(weakSelf);
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = wxPayGoodsRequest;
    config.requestParameters = @{@"goodId":GetString(self.storeModel.storeId),
                                 @"fromUserId":GetString([AppDelegate shareDelegate].userModel.userId),
                                 @"payType":GetString(self.payType)
                                 };
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        if (!error) {
            if ([result[@"code"] integerValue] == 200) {
                if([weakSelf.payType isEqualToString:@"zfbPay"]){
                    [weakSelf payToALiPayWithString:result[@"data"][@"body"]];
                }else if([weakSelf.payType isEqualToString:@"wxPay"]){
                    if (!WXApi.isWXAppInstalled) {
                        [CAToast showWithText:@"请安装微信"];
                        return;
                    }
                    [weakSelf payToWeChatWithDic:result[@"data"]];
                    //                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
            }
        }
    }];
}
- (void)payToWeChatWithDic:(NSDictionary *)dic
{
    // App-培训详情-微信支付
    //    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObject:self.detailModel.title forKey:@"title"];
    //    if ([self.detailModel.courseTypeId isEqualToString:@"1"]) {
    //        [param setObject:@"精品课" forKey:@"type"];
    //    } else {
    //        [param setObject:@"培训班" forKey:@"type"];
    //    }
    //    SensorsAnalyticsTrack(@"app_peixunxiangqing_weixinzhifu", param);
    //
    
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = dic[@"partnerid"];  // 商户号
    request.prepayId = dic[@"prepayid"]; // 预支付交易会话ID
    request.package = dic[@"package"];    // 扩展字段(固定值)
    request.nonceStr = dic[@"noncestr"]; // 随机字符串
    NSString *timeStampString = dic[@"timestamp"];
    if (!IsExist_String(timeStampString)) return;
    UInt32 num;
    sscanf([timeStampString UTF8String], "%u", &num);
    request.timeStamp = num;     // 时间戳
    request.sign = dic[@"sign"]; // 签名
    [WXApi sendReq:request];
}
#pragma mark - WXApiManagerDelegate
- (void)onResp:(BaseResp *)resp{
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        // 返回结果 0:成功 -1:错误 -2:用户取消
        if (response.errCode == -2) {
            [CAToast showWithText:@"用户取消"];
            return;
        }
        if (response.errCode == 0) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
    }
}
- (void)payToALiPayWithString:(NSString *)string
{
    // App-培训详情-支付宝支付
    //    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObject:self.detailModel.title forKey:@"title"];
    //    if ([self.detailModel.courseTypeId isEqualToString:@"1"]) {
    //        [param setObject:@"精品课" forKey:@"type"];
    //    } else {
    //        [param setObject:@"培训班" forKey:@"type"];
    //    }
    //    SensorsAnalyticsTrack(@"app_peixunxiangqing_zhifubaozhifu", param);
    
    WS(weakSelf);
    [[AlipaySDK defaultService] payOrder:string fromScheme:@"com.hhlmcn.huihuilinmeng" callback:^(NSDictionary *resultDic) {
        NSLog(@"status:%@ reslut = %@", resultDic[@"resultStatus"], resultDic[@"result"]);
        NSString *resultStatus = resultDic[@"resultStatus"];
        if ([resultStatus isEqualToString:@"9000"]) {
            NSLog(@"支付成功");
            [weakSelf.navigationController popViewControllerAnimated:YES];
            //            [weakSelf queryPayStatus];
        } else if ([resultStatus isEqualToString:@"4000"]) {
            [CAToast showWithText:@"支付失败"];
        } else if ([resultStatus isEqualToString:@"5000"]) {
            [CAToast showWithText:@"支付订单重复"];
        } else if ([resultStatus isEqualToString:@"6001"]) {
            NSLog(@"支付取消");
            return;
        } else if ([resultStatus isEqualToString:@"6002"]) {
            [CAToast showWithText:@"请检查网络连接"];
        } else {
            [CAToast showWithText:@"支付错误"];
        }
    }];
}
- (void)payToScoreGoods{
    WS(weakSelf);
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = scorePayGoodsRequest;
    config.requestParameters = @{@"goodId":GetString(self.storeModel.storeId),@"userId":GetString([AppDelegate shareDelegate].userModel.userId)};
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        if (!error) {
            [CAToast showWithText:result[@"msg"]];
            if([result[@"code"] integerValue] == 200)
             [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [CAToast showWithText:@"支付失败"];
        }
    }];
}
- (void)showAddressView{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        WS(weakSelf);
        [GLD_ExpressAddressView expressAddressView:^(NSString *address) {
            weakSelf.address = address;
            [weakSelf hasWriteAddress];
        }];
    });
}
- (UIButton *)applyBut{
    if (!_applyBut) {
        _applyBut = [[UIButton alloc]init];
        [_applyBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKwirte] forState:UIControlStateNormal];
        [_applyBut setTitle:@"立即购买" forState:UIControlStateNormal];
        _applyBut.titleLabel.font = WTFont(15);
        _applyBut.layer.cornerRadius = 3;
        _applyBut.layer.masksToBounds = YES;
        _applyBut.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE];
//        _applyBut.hidden = YES;
        [_applyBut addTarget:self action:@selector(applybutClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyBut;
}
@end
