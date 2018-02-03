//
//  GLD_PayForBusinessController.m
//  lingzhi
//
//  Created by rabbit on 2018/2/3.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_PayForBusinessController.h"
#import "GLD_PayForBusiCell.h"
#import "GLD_PayForBusiModel.h"


typedef enum
{
    WeChatPay = 0,
    AliPay,
    offLine
}PayType;

@interface GLD_PayForBusinessController ()<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate,GLD_PayForBusiCellDelegate>

@property (nonatomic, strong)UITableView *table_apply;
@property (nonatomic, strong) NSArray *titleArr;//
@property (nonatomic, strong)UIImageView *generalRankImgV;//全额支付
@property (nonatomic, strong)UIImageView *superRankImgV;//分期付款

@property (nonatomic, strong)UIImageView *zhiFuBaoImgV;//全额支付
@property (nonatomic, strong)UIImageView *weiChatImgV;//微信付款
@property (nonatomic, strong)UIImageView *offLineImgV;//线下付款
@property (nonatomic, strong)UILabel *footerTipLabel;//
@property (nonatomic, strong)UIButton *footerTipBut;
@property (nonatomic, strong)UIButton *applyBut;//升级
@property (nonatomic, assign) PayType payType;
@property (nonatomic, weak)UITableViewCell *counpCell;//

@property (nonatomic, weak)UILabel *cashLabel;//

@property (nonatomic, strong) GLD_NetworkAPIManager *NetManager;//
@property (nonatomic, strong) GLD_PayForBusiModel *payMainModel;//
@property (nonatomic, assign) CGFloat payMoney;//要支付的钱
@property (nonatomic, assign) CGFloat payCoupon;//预付的代金券
@end

@implementation GLD_PayForBusinessController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.table_apply];
    self.NetManager = [GLD_NetworkAPIManager new];
    self.payType = WeChatPay;
    [self setuBottomView];
    [self getData];
    self.title = @"支付";
}

- (void)getData{
    
    WS(weakSelf);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (IsExist_String(self.payForUserId)) {
        [dict addEntriesFromDictionary:@{@"userId":self.payForUserId}];
    }
    
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/user/payInfo";
    config.requestParameters = dict;
    
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        
        if(!error){
           
            weakSelf.payMainModel = [[GLD_PayForBusiModel alloc]initWithDictionary:result[@"data"] error:nil];
            weakSelf.counpCell.textLabel.text = [NSString stringWithFormat:@"代金券(%@)",weakSelf.payMainModel.coupon];
            [weakSelf.table_apply reloadData];
        }
        //        weakSelf.phoneCode = @"1111";
    }];
    
    
}
- (void)setuBottomView{
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    UILabel *tipLabel = [UILabel creatLableWithText:@"实际支付：" andFont:WTFont(12) textAlignment:NSTextAlignmentLeft textColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKblackNew]];
    
    UILabel *cashLabel = [UILabel creatLableWithText:@"￥ 0" andFont:WTFont(15) textAlignment:NSTextAlignmentLeft textColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTred]];
    self.cashLabel = cashLabel;
    
    [self.view addSubview:bottomView];
    [bottomView addSubview:tipLabel];
    [bottomView addSubview:cashLabel];
    [bottomView addSubview:self.applyBut];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self.view);
        make.height.equalTo(WIDTH(50));
    }];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView);
        make.left.equalTo(bottomView).offset(15);
    }];
    
    [cashLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView);
        make.left.equalTo(tipLabel.mas_right);
    }];
    
    [self.applyBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(bottomView);
        make.width.equalTo(WIDTH(100));
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section != 2)
        return 1;
    return self.titleArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:{
            
            return [self getPayForBusiCell:indexPath];
        }break;
        case 1:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"counpCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"counpCell"];
            }
            self.counpCell = cell;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKblackNew];
            
            return cell;
        }break;
        case 2:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKblackNew];
            NSDictionary *ditt = self.titleArr[indexPath.row];
            cell.imageView.image = WTImage(ditt[@"image"]);
            cell.textLabel.text = ditt[@"title"];
            if (indexPath.row == 0) {
                [cell.contentView addSubview:self.weiChatImgV];
            }else if(indexPath.row == 1){
                [cell.contentView addSubview:self.zhiFuBaoImgV];
            }else{
                [cell.contentView addSubview:self.offLineImgV];
            }
            return cell;
        }break;
    }
    return [UITableViewCell new];
}


- (GLD_PayForBusiCell *)getPayForBusiCell:(NSIndexPath *)indexPath{
    GLD_PayForBusiCell *cell = [GLD_PayForBusiCell cellWithReuseIdentifier:@"GLD_PayForBusiCell"];
    cell.payDelegate = self;
    cell.busnessModel = self.payMainModel.shop;
    
    return cell;
}
- (void)updatePayCash:(NSString *)money{
    NSLog(@"%lf", money.floatValue);
    self.payMoney = money.floatValue;
    CGFloat discount = (10 - self.payMainModel.shop.discount.floatValue)/10.0;
    CGFloat ff = money.floatValue * discount;
    self.payCoupon = ff*self.payMainModel.discount.floatValue;
    
    self.counpCell.detailTextLabel.text = [NSString stringWithFormat:@"%.2lf",-ff*self.payMainModel.discount.floatValue];
    self.cashLabel.text = [NSString stringWithFormat:@"￥ %.2f", money.floatValue - ff*self.payMainModel.discount.floatValue];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return W(100);
    }
    return W(44);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *headView = [UITableViewHeaderFooterView new];
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = WTFont(12);
    titleLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTnewGray];
    if (section == 1) {
        titleLabel.text = @"优惠抵扣";
    }else if(section == 2){
        titleLabel.text = @"请选择支付方式";
    }
    [headView.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(headView.contentView);
    }];
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return 0.001;
    return W(30);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
   
    return 0.01;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                self.generalRankImgV.hidden = NO;
                self.superRankImgV.hidden = YES;
                self.footerTipBut.hidden = YES;
                self.footerTipLabel.hidden = YES;
            }else{
                self.generalRankImgV.hidden = YES;
                self.superRankImgV.hidden = NO;
                self.footerTipBut.hidden = NO;
                self.footerTipLabel.hidden = NO;
            }
            [tableView reloadData];
        }break;
        case 2:{
            if (indexPath.row == 0) {
                self.weiChatImgV.hidden = NO;
                self.zhiFuBaoImgV.hidden = YES;
                self.payType = WeChatPay;
                self.offLineImgV.hidden = YES;
            }else if(indexPath.row == 1){
                self.weiChatImgV.hidden = YES;
                self.zhiFuBaoImgV.hidden = NO;
                self.payType = AliPay;
                self.offLineImgV.hidden = YES;
            }else{
                self.weiChatImgV.hidden = YES;
                self.zhiFuBaoImgV.hidden = YES;
                self.payType = offLine;
                self.offLineImgV.hidden = NO;
            }
        }break;
            
    }
}
//
- (void)footerTipButClick{
//    GLD_PayRechargeController *payVc = [GLD_PayRechargeController new];
//    [self.navigationController pushViewController:payVc animated:YES];
}

//升级
- (void)applybutClick{
    
    if (self.payMoney < 0) {
        [CAToast showWithText:@"请输入金额"];
        return;
    }
    if (self.payType == offLine) {
        if (self.payMoney * 0.1 > self.payMainModel.cash.floatValue) {
            [CAToast showWithText:@"服务费不足，请充值"];
            return;
        }
    }
    WS(weakSelf);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (IsExist_String(self.payForUserId)) {
        [dict addEntriesFromDictionary:@{@"toUserId":self.payForUserId}];
    }
    
    
    [dict addEntriesFromDictionary:@{@"amount" : [NSString stringWithFormat:@"%.2f",self.payMoney],
                                     @"payType" :self.payType == offLine ? @"offLine": (self.payType == AliPay ? @"zfbPay" : @"wxPay"),
                                     @"fromUserId" : GetString([AppDelegate shareDelegate].userModel.userId),
                                     @"coupon" :[NSString stringWithFormat:@"%.2f",self.payCoupon]
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
                }else if(weakSelf.payType == offLine){
                    [CAToast showWithText:@"支付成功"];
                }
                return ;
            }else{
                [CAToast showWithText:@"支付失败，请重试！"];
            }
            
        }
        //        weakSelf.phoneCode = @"1111";
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
            return;
        }
        
     
    }
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
        tableView.mj_insetB = W(50);
        //        [tableView registerClass:[GLD_MapDetailCell class] forCellReuseIdentifier:GLD_MapDetailCellIdentifier];
        //        tableView.rowHeight = 0;
        tableView.sectionFooterHeight = 0.001;
    }
    return _table_apply;
}
- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[@{@"title":@"微信",@"image":@"微信支付"},
                      @{@"title":@"支付宝",@"image":@"支付宝-2 copy"},
                      @{@"title":@"线下",@"image":@"支付宝-2 copy"}];
    }
    return _titleArr;
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
- (UIImageView *)zhiFuBaoImgV{
    if (!_zhiFuBaoImgV) {
        _zhiFuBaoImgV = [[UIImageView alloc]initWithImage:WTImage(@"粗勾")];
        _zhiFuBaoImgV.frame = CGRectMake( W(340), W(10), W(20), H(20));
        _zhiFuBaoImgV.hidden = YES;
    }
    return _zhiFuBaoImgV;
}
- (UIImageView *)weiChatImgV{
    if (!_weiChatImgV) {
        _weiChatImgV = [[UIImageView alloc]initWithImage:WTImage(@"粗勾")];
        _weiChatImgV.frame = CGRectMake( W(340), W(10), W(20), H(20));
//        _weiChatImgV.hidden = YES;
    }
    return _weiChatImgV;
}
- (UIImageView *)offLineImgV{
    if (!_offLineImgV) {
        _offLineImgV = [[UIImageView alloc]initWithImage:WTImage(@"粗勾")];
        _offLineImgV.frame = CGRectMake( W(340), W(10), W(20), H(20));
        _offLineImgV.hidden = YES;
        //        _weiChatImgV.hidden = YES;
    }
    return _offLineImgV;
}
- (UIButton *)footerTipBut{
    if (!_footerTipBut) {
        _footerTipBut = [UIButton new];
        [_footerTipBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE] forState:UIControlStateNormal];
        [_footerTipBut addTarget:self action:@selector(footerTipButClick) forControlEvents:UIControlEventTouchUpInside];
        _footerTipBut.hidden = YES;
        [_footerTipBut setTitle:@"立即充值" forState:UIControlStateNormal];
        _footerTipBut.titleLabel.font = WTFont(12);
    }
    return _footerTipBut;
}
- (UILabel *)footerTipLabel{
    if (!_footerTipLabel) {
        _footerTipLabel = [UILabel new];
        _footerTipLabel.font = WTFont(12);
        _footerTipLabel.hidden = YES;
        _footerTipLabel.text = @"余额不足";
        _footerTipLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTRED];
    }
    return _footerTipLabel;
}
- (UIButton *)applyBut{
    if (!_applyBut) {
        _applyBut = [[UIButton alloc]init];
        [_applyBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKwirte] forState:UIControlStateNormal];
        [_applyBut setTitle:@"立即支付" forState:UIControlStateNormal];
        _applyBut.titleLabel.font = WTFont(15);
//        _applyBut.layer.cornerRadius = 3;
        _applyBut.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKyellow];
//        _applyBut.layer.masksToBounds = YES;
//        _applyBut.layer.borderColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKyellow].CGColor;
//        _applyBut.layer.borderWidth = 1;
        [_applyBut addTarget:self action:@selector(applybutClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyBut;
}
@end
