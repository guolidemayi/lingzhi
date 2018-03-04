//
//  GLD_PayRechargeController.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/13.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_PayRechargeController.h"
#import "GLD_CashCountCell.h"
#import <AlipaySDK/AlipaySDK.h>

typedef enum
{
    WeChatPay = 0,
    AliPay,
    BankPay
}PayType;

@interface GLD_PayRechargeController ()<UITableViewDelegate, UITableViewDataSource,WXApiManagerDelegate>
@property (nonatomic, strong)UITableView *table_apply;
@property (nonatomic, strong)NSArray *dataArr;
@property (nonatomic, strong)UIButton *applyBut;//现金
@property (nonatomic, weak)GLD_CashCountCell *cashCell;
@property (nonatomic, strong) GLD_NetworkAPIManager *NetManager;//
@property (nonatomic, strong)UIImageView *generalRankImgV;//普通商家
@property (nonatomic, strong)UIImageView *superRankImgV;//高级商家商家

@property (nonatomic, assign) PayType payType;
@end

@implementation GLD_PayRechargeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.table_apply];
    self.NetManager = [GLD_NetworkAPIManager new];
    self.payType = AliPay;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [WXApiManager sharedManager].delegate = self;
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
    if (!WXApi.isWXAppInstalled) {
        [CAToast showWithText:@"请安装微信"];
        return;
    }
    
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
- (void)queryPayStatus{
    
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/wx/weixinPay";
    config.requestParameters = @{@"userId":GetString([AppDelegate shareDelegate].userModel.userId)};
    
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        
        if(!error){
            if ([result[@"code"] integerValue] != 200) {
                
                [CAToast showWithText:result[@"msg"]];
                return ;
            }else{
                [CAToast showWithText:@"支付成功"];
            }
            
        }
        //        weakSelf.phoneCode = @"1111";
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.dataArr.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = [UITableViewHeaderFooterView new];
    [header.contentView addSubview:self.applyBut];
    [self.applyBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(header.contentView);
        make.width.equalTo(WIDTH(300));
        make.height.equalTo(WIDTH(44));
    }];
    return header;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
            
        case 1:{
            
            if (indexPath.row == 0) {
                self.payType = AliPay;
                self.superRankImgV.hidden = YES;
                self.generalRankImgV.hidden = NO;
            }else{
                self.payType = WeChatPay;
                self.superRankImgV.hidden = NO;
                self.generalRankImgV.hidden = YES;
            }
            [tableView reloadData];
        }break;
            
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *headView = [UITableViewHeaderFooterView new];
    UILabel *textLabel = [UILabel creatLableWithText:@"" andFont:WTFont(12) textAlignment:NSTextAlignmentLeft textColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTline2Gray]];
    [headView.contentView addSubview:textLabel];
    if (section == 0) {
        textLabel.text = @"请选择金额";
    }else{
        textLabel.text = @"请选择支付方式";
    }
    textLabel.frame = CGRectMake(0, 0, W(200), H(44));
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return W(44);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) return W(70);
    return 0.001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return [self getCooperatCell:indexPath];
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cashCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cashCell"];
        }
        cell.textLabel.font = WTFont(15);
        cell.detailTextLabel.font = WTFont(12);
        NSDictionary *dict =  self.dataArr[indexPath.row];
        cell.textLabel.text = dict[@"title"];
        cell.detailTextLabel.text =dict[@"tip"];
        cell.imageView.image = WTImage(dict[@"image"]);
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        switch (indexPath.row) {
            case 0:{
                [cell.contentView addSubview:self.generalRankImgV];
            }break;
            case 1:{
                [cell.contentView addSubview:self.superRankImgV];
            }break;
        }
        return cell;
    }
}
- (UIImageView *)generalRankImgV{
    if (!_generalRankImgV) {
        _generalRankImgV = [[UIImageView alloc]initWithImage:WTImage(@"粗勾")];
        _generalRankImgV.frame = CGRectMake( W(340), W(10), W(20), H(20));
    }
    return _generalRankImgV;
}
- (UIImageView *)superRankImgV{
    if (!_superRankImgV) {
        _superRankImgV = [[UIImageView alloc]initWithImage:WTImage(@"粗勾")];
        _superRankImgV.frame = CGRectMake( W(340), W(10), W(20), H(20));
        _superRankImgV.hidden = YES;
    }
    return _superRankImgV;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return W(100);
    }else{
        return W(44);
    }
}
- (GLD_CashCountCell *)getCooperatCell:(NSIndexPath *)indexPath{
    GLD_CashCountCell *cell = [self.table_apply dequeueReusableCellWithIdentifier:GLD_CashCountCellIdentifier];
    self.cashCell = cell;
    return cell;
}
- (NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = @[
                     @{@"title":@"支付宝支付",@"tip":@"需要安装支付宝客户端",@"image":@"支付宝-2 copy"},
                     @{@"title":@"微信支付",@"tip":@"需要安装微信客户端",@"image":@"微信支付"}];
    }
    return _dataArr;
}
- (UITableView *)table_apply{
    if (!_table_apply) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        self.table_apply = tableView;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        [tableView setSeparatorInset:UIEdgeInsetsMake(0, W(15), 0, W(15))];
        tableView.rowHeight = W(60);
        [tableView registerClass:[GLD_CashCountCell class] forCellReuseIdentifier:GLD_CashCountCellIdentifier];
        //        tableView.rowHeight = 0;
        tableView.sectionFooterHeight = 0.001;
    }
    return _table_apply;
}

- (void)applybutClick{
    if (!IsExist_String(self.cashCell.moneyStr)) {
        [CAToast showWithText:@"请输入充值金额"];
        return;
    }
    WS(weakSelf);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (IsExist_String(self.payForUserId)) {
        [dict addEntriesFromDictionary:@{@"toUserId":self.payForUserId}];
    }
    
    [dict addEntriesFromDictionary:@{@"amount" : [NSString stringWithFormat:@"%zd",self.cashCell.moneyStr.integerValue],
                                     @"payType" : self.payType == AliPay ? @"zfbPay" : @"wxPay",
                                     @"fromUserId" : GetString([AppDelegate shareDelegate].userModel.userId)
                                     }];
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/wx/weixinPay";
    config.requestParameters = dict;
    
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        
        if(!error){
            if ([result[@"code"] integerValue] == 200) {
                if(weakSelf.payType == AliPay){
                    
                }else if(weakSelf.payType == WeChatPay){
                    
                    [weakSelf payToWeChatWithDic:result[@"data"]];
                }
                return ;
            }else{
                [CAToast showWithText:@"支付失败，请重试！"];
            }
            
        }
        //        weakSelf.phoneCode = @"1111";
    }];
    
    
    NSLog(@"%@",self.cashCell.moneyStr);
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
- (UIButton *)applyBut{
    if (!_applyBut) {
        _applyBut = [[UIButton alloc]init];
        [_applyBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKyellow] forState:UIControlStateNormal];
        [_applyBut setTitle:@"立即充值" forState:UIControlStateNormal];
        _applyBut.titleLabel.font = WTFont(15);
        _applyBut.layer.cornerRadius = 3;
        _applyBut.layer.masksToBounds = YES;
        _applyBut.layer.borderColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKyellow].CGColor;
        _applyBut.layer.borderWidth = 1;
        [_applyBut addTarget:self action:@selector(applybutClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyBut;
}
@end
