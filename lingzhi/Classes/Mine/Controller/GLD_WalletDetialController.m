//
//  GLD_WalletDetialController.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/12.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_WalletDetialController.h"
#import "GLD_GiveCouponController.h"
#import "GLD_PayRechargeController.h"
#import "GLD_GetCashController.h"

@interface GLD_WalletDetialController ()
@property (nonatomic, strong)UIImageView *iconImgV;
@property (nonatomic, strong)UILabel *titleLabel;//标题
@property (nonatomic, strong)UILabel *tipLabel;//副标题
@property (nonatomic, strong)UILabel *cashLabel;//现金
@property (nonatomic, strong)UIButton *applyBut;//现金

@property (nonatomic, strong)NSArray *dataArr;
@end

@implementation GLD_WalletDetialController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    [self layout];
    [self setData];
}


- (void)applybutClick{
    if ([self.applyBut.titleLabel.text isEqualToString:@"转赠"]) {
        NSLog(@"转赠");
        GLD_GiveCouponController *giveVc = [GLD_GiveCouponController new];
        [self.navigationController pushViewController:giveVc animated:YES];
    }else if([self.applyBut.titleLabel.text isEqualToString:@"充值"]){
        GLD_PayRechargeController *payVc = [GLD_PayRechargeController new];
        [self.navigationController pushViewController:payVc animated:YES];
    }else if([self.applyBut.titleLabel.text isEqualToString:@"提现"]){
        GLD_GetCashController *payVc = [GLD_GetCashController new];
        [self.navigationController pushViewController:payVc animated:YES];
    }
}


- (void)setData{
    self.iconImgV.image = WTImage(self.dataArr[0]);
    self.titleLabel.text = self.dataArr[1];
    NSString *butStr = self.dataArr[2];
    switch (self.type) {
        case 1:{
            self.cashLabel.text = [NSString stringWithFormat:@"￥ %@",[AppDelegate shareDelegate].userModel.cash1];
            self.applyBut.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKyellow];
            [self.applyBut setTitle:butStr forState:UIControlStateNormal];
        }break;
        case 2:{
            self.cashLabel.text = [NSString stringWithFormat:@"%@",[AppDelegate shareDelegate].userModel.cash1];
            self.applyBut.hidden = YES;
        }break;
        case 3:{
            self.cashLabel.text = [NSString stringWithFormat:@"%@",[AppDelegate shareDelegate].userModel.cash3];
            self.applyBut.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKgray2];
            [self.applyBut setTitle:butStr forState:UIControlStateNormal];
        }break;
        case 4:{
            self.cashLabel.text = [NSString stringWithFormat:@"%@",[AppDelegate shareDelegate].userModel.cash1];
            self.applyBut.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE];
            [self.applyBut setTitle:butStr forState:UIControlStateNormal];
        }break;
    }
    
}

- (NSArray *)dataArr{
    if (!_dataArr) {
        switch (self.type) {
            case 1:{
                _dataArr = @[@"realNmaeIdentification",@"现金可以自由支配，包括但不限于：在联盟商家购物、绑卡提现、商家预存服务费等（提现产生的个人所得税和银行手续费由个人自理，平台代收的商家营业款除外）",@"提现"];
            }break;
            case 2:{
                _dataArr = @[@"realNmaeIdentification",@"L币是会员在高级联盟商家消费购物后，平台给予高级联盟商家折让部分的一种补贴待用币",@""];
            }break;
            case 3:{
                _dataArr = @[@"realNmaeIdentification",@"平台均为商家开通了赠送“通用优惠券“功能；”通用优惠券“可在联盟商家抵用现金",@"转赠"];
            }break;
            case 4:{
                _dataArr = @[@"realNmaeIdentification",@"联盟会员在联盟商家消费，平台按合同约定扣去商家的折扣分金，商家如开通线下支付，需要预存适量服务费，如走线上则不需要",@"充值"];
            }break;
        }
    }
    return _dataArr;
}
- (void)setupUI{
    [self.view addSubview:self.iconImgV];
    [self.view addSubview:self.titleLabel];
//    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.cashLabel];
    [self.view addSubview:self.applyBut];
    
}
- (void)layout{
    [self.iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(W(80));
        make.width.height.equalTo(WIDTH(80));
    }];
    [self.cashLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.iconImgV.mas_bottom).offset(W(20));
        
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.cashLabel.mas_bottom).offset(W(30));
        make.width.equalTo(WIDTH(300));
    }];
//    [self.iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view);
//        make.top.equalTo(self.view).offset(W(80));
//        make.width.height.equalTo(WIDTH(80));
//    }];
    [self.applyBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(W(-80));
        make.width.equalTo(WIDTH(250));
        make.height.equalTo(WIDTH(44));
    }];
}
- (UIImageView *)iconImgV{
    if (!_iconImgV) {
        _iconImgV = [UIImageView new];
        _iconImgV.image = WTImage(@"更多");
    }
    return _iconImgV;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = WTFont(12);
        _titleLabel.text = @"我的钱包";
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTnewGray];
    }
    return _titleLabel;
}
- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.font = WTFont(12);
        _tipLabel.text = @"管理我的钱包";
        _tipLabel.textAlignment = NSTextAlignmentRight;
        _tipLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTnewGray];
    }
    return _tipLabel;
}


- (UILabel *)cashLabel{
    if (!_cashLabel) {
        _cashLabel = [UILabel new];
        _cashLabel.font = WTFont(17);
        _cashLabel.textAlignment = NSTextAlignmentCenter;
        _cashLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK];
    }
    return _cashLabel;
}

- (UIButton *)applyBut{
    if (!_applyBut) {
        _applyBut = [[UIButton alloc]init];
        [_applyBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKwirte] forState:UIControlStateNormal];
        [_applyBut setTitle:@"申请合作" forState:UIControlStateNormal];
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
