//
//  GLD_NewPostExressController.m
//  lingzhi
//
//  Created by 锅里的 on 2019/5/15.
//  Copyright © 2019 com.lingzhi. All rights reserved.
//

#import "GLD_NewPostExressController.h"
#import "GLD_ExpressModel.h"
#import "GLD_PostExressManager.h"
#import "GLD_PostTypeManager.h"
#import <AlipaySDK/AlipaySDK.h>

@interface GLD_NewPostExressController ()<WXApiManagerDelegate,GLD_PostTypeManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GLD_PostTypeManager *postTypeManager;
@property (nonatomic, strong) GLD_PostExressManager *postManager;
@property (nonatomic, strong) UIButton *postBut;
@property (nonatomic, assign) NSString *payType;
@end

@implementation GLD_NewPostExressController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.postManager = [[GLD_PostExressManager alloc]initWith:self.tableView andViewC:self];
    self.postTypeManager = [[GLD_PostTypeManager alloc]initWithDelegate:self];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    [WXApiManager sharedManager].delegate = self;
}
- (void)didSeletedPoseType:(NSInteger)type{
    self.postManager.expressModel.type = @(type);
    [self.postManager reloadData];
}
- (void)postClick{
    if(!IsExist_String(self.postManager.expressModel.start)){
        [CAToast showWithText:@"请选择出发地点"];
        return;
    }
    if(!IsExist_String(self.postManager.expressModel.end)){
        [CAToast showWithText:@"请选择配送地点"];
        return;
    }
    if(self.postManager.expressModel.price <= 0){
        [CAToast showWithText:@"请输入价格"];
        return;
    }
    if(!IsExist_String(self.postManager.expressModel.phone)){
        [CAToast showWithText:@"请输入手机号"];
        return;
    }
    if(!IsExist_String(self.postManager.expressModel.title)){
        [CAToast showWithText:@"请输入商品描述及备注"];
        return;
    }
    if(self.postManager.expressModel.type.integerValue != 2 &&  !IsExist_String(self.postManager.expressModel.receivedPhone)){
        [CAToast showWithText:@"请输入收件人手机号"];
        return;
    }
    if(self.postManager.expressModel.type.integerValue != 2 &&  !IsExist_String(self.postManager.expressModel.receivedPerson)){
        [CAToast showWithText:@"请输入收件人"];
        return;
    }
    if(self.postManager.expressModel.type.integerValue != 2 &&  !IsExist_String(self.postManager.expressModel.goodsPic)){
        [CAToast showWithText:@"请选择收件人"];
        return;
    }
    [self showChoosePayTypeAlert];
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
    config.urlPath = sendExpressRequest;
    config.requestParameters = @{@"end":self.postManager.expressModel.end,
                                 @"start":GetString(self.postManager.expressModel.start),
                                 @"price":@(self.postManager.expressModel.price),
                                 @"title":self.postManager.expressModel.title,
                                 @"phone":self.postManager.expressModel.phone,  @"lat":@(self.postManager.expressModel.latitude),
                                 @"lng":@(self.postManager.expressModel.longitude),
                                 @"toLat":@(self.postManager.expressModel.toLatitude),
                                 @"toLng":@(self.postManager.expressModel.toLongitude),
                                 @"userId":GetString([AppDelegate shareDelegate].userModel.userId),
                                 @"city":GetString(self.postManager.expressModel.city),
                                 @"receivedPerson":GetString(self.postManager.expressModel.receivedPerson),
                                 @"receivedPhone":GetString(self.postManager.expressModel.receivedPhone),
                                 @"goodsPic":GetString(self.postManager.expressModel.goodsPic),
                                 @"type":self.postManager.expressModel.type,
                                 @"payType":self.payType,
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

- (void)setupUI{
    [self.view addSubview:self.postTypeManager.collectionView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.postBut];
    
    [self.postTypeManager.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.equalTo(@(44));
        
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.view);
        make.top.equalTo(self.postTypeManager.collectionView.mas_bottom);
        make.bottom.equalTo(self.postBut.mas_top);
    }];
    [self.postBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-20);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@(44));
        make.width.equalTo(@(345));
    }];
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, DEVICE_WIDTH, DEVICE_HEIGHT-60) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.scrollEnabled = NO;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.sectionIndexBackgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0];
        _tableView.sectionIndexColor = [UIColor blueColor];
        
    }
    return _tableView;
}
- (UIButton *)postBut{
    if (!_postBut) {
        _postBut = [[UIButton alloc]init];
        [_postBut setTitle:@"提交" forState:UIControlStateNormal];
        _postBut.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE];
        _postBut.layer.cornerRadius = 5;
        [_postBut addTarget:self action:@selector(postClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _postBut;
}
@end
