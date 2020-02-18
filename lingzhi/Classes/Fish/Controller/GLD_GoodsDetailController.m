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
#import "GLD_ChooseGoodsView.h"
#import "GLD_MessageUserInfoTool.h"
#import "GLD_GoodsCarListController.h"
#import "YXButton.h"
@interface GLD_GoodsDetailController ()<WXApiManagerDelegate,GLD_ChooseGoodsViewDelegate>
@property (nonatomic, strong)GLD_GoodsDetailManager *goodsDetailManager;
@property (nonatomic, strong)UITableView *home_table;
@property (nonatomic, strong)UIButton *applyBut;
@property (nonatomic, strong) UIButton *addToCar;//添加购物车
@property (nonatomic, strong) YXButton *carBut;//购物车
@property (nonatomic, assign) NSString *payType;
@property (nonatomic, strong)NSString *address;
@property (nonatomic, strong) GLD_ChooseGoodsView *chooseGoodsView;

@end

@implementation GLD_GoodsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.address = @"";
    [self setApplyBut];
    self.home_table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
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
    [self.view addSubview:self.addToCar];
    [self.view addSubview:self.carBut];
    [self.applyBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.view);
        make.width.equalTo(@(DEVICE_WIDTH / 2));
        make.height.equalTo(@(44));
    }];
    [self.addToCar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.carBut);
        make.left.equalTo(self.carBut.mas_right);
//        make.right.equalTo(self.applyBut.mas_left);
        make.width.equalTo(@(DEVICE_WIDTH/2 -44));
        make.height.equalTo(@(44));
    }];
    
    [self.carBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.equalTo(self.view);
        make.height.equalTo(@(44));
        make.width.equalTo(@(44));
    }];
    
}
//GLD_ChooseGoodsViewDelegate
- (void)didSelectedTimeItem:(NSString *)index andChooseCount:(NSInteger)count{
    [self.navigationController.view sendSubviewToBack:self.chooseGoodsView];
    if (index.length != 0) {
#warning __规格
    }
    self.storeModel.chooseNorms = index;
    self.storeModel.seleteCount = count;
    if(self.type == 2){
        [self hasWriteAddress];
    }else{
        [self showAddressView];
    }
}
//click
- (void)applybutClick{
    if (hasLogin) {
    
        [self.navigationController.view bringSubviewToFront:self.chooseGoodsView];
    }else{
        [CAToast showWithText:@"请登录"];
    }
}
- (void)addToCarClick{
    if (hasLogin) {
        [GLD_MessageUserInfoTool writeDiskCache:self.storeModel];
    }else{
        [CAToast showWithText:@"请登录"];
    }
}
- (void)carButClick{
    GLD_GoodsCarListController *goodVc = [GLD_GoodsCarListController new];
    [self.navigationController pushViewController:goodVc animated:YES];
    
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
    payVc.payPrice = self.storeModel.price.floatValue * self.storeModel.seleteCount;
    payVc.stroeModel = self.storeModel;
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
    config.requestParameters = @{@"goodsId":GetString(self.storeModel.storeId),
                                 @"fromUserId":GetString([AppDelegate shareDelegate].userModel.userId),
                                 @"payType":GetString(self.payType),
                                 @"address":GetString(self.address),
                                 @"prize":self.storeModel.price
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
    config.requestParameters = @{@"goodId":GetString(self.storeModel.storeId),@"userId":GetString([AppDelegate shareDelegate].userModel.userId),@"address":GetString(self.address)};
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
//        _applyBut.layer.cornerRadius = 3;
//        _applyBut.layer.masksToBounds = YES;
        _applyBut.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE];
//        _applyBut.hidden = YES;
        [_applyBut addTarget:self action:@selector(applybutClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyBut;
}
- (UIButton *)addToCar{
    if (!_addToCar) {
        _addToCar = [[UIButton alloc]init];
        [_addToCar setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTorange] forState:UIControlStateNormal];
        [_addToCar setTitle:@"加入购物车" forState:UIControlStateNormal];
        _addToCar.titleLabel.font = WTFont(15);
//        _addToCar.layer.cornerRadius = 3;
//        _addToCar.layer.masksToBounds = YES;
//        _addToCar.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTorange];
        //        _applyBut.hidden = YES;
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 5, 1, 35)];
        lineView.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTline2Gray];
        [_addToCar addSubview:lineView];
        [_addToCar addTarget:self action:@selector(addToCarClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addToCar;
}
- (YXButton *)carBut{
    if (!_carBut) {
        _carBut = [[YXButton alloc]init];
        _carBut.imgV.image = WTImage(@"Home_Versionf_ShoppingCart");
        _carBut.label.text = @"购物车";
        _carBut.label.font = WTFont(10);
//        _carBut.titleLabel.textColor = [UIColor blackColor];
//        [_carBut setImage:WTImage(@"Home_Versionf_ShoppingCart") forState:UIControlStateNormal];
        [_carBut addTarget:self action:@selector(carButClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _carBut;
}
- (GLD_ChooseGoodsView *)chooseGoodsView{
    if (!_chooseGoodsView) {
        GLD_ChooseGoodsView *chooseV = [GLD_ChooseGoodsView instanceChooseGoodsView];
        _chooseGoodsView = chooseV;
        _chooseGoodsView.timeDelegate = self;
        _chooseGoodsView.storeModel = self.storeModel;
        _chooseGoodsView.frame = [UIScreen mainScreen].bounds;
        [self.navigationController.view insertSubview:_chooseGoodsView atIndex:0];
        [self.navigationController.view sendSubviewToBack:_chooseGoodsView];
    }
    return _chooseGoodsView;
}
- (void)dealloc{
    [_chooseGoodsView removeFromSuperview];
    _chooseGoodsView.timeDelegate = nil;
}
@end
