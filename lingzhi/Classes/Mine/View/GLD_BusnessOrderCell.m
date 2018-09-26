//
//  GLD_BusnessOrderCell.m
//  lingzhi
//
//  Created by yiyangkeji on 2018/7/3.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_BusnessOrderCell.h"

@interface GLD_BusnessOrderCell ()

@property (weak, nonatomic) IBOutlet UILabel *orderCodeLabel;//订单
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;//确认

@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;//店面图标
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//点名
@property (weak, nonatomic) IBOutlet UILabel *cashLabel;//现金
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;//券
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;//日期
@property (weak, nonatomic) IBOutlet UIButton *commentBut;//评价
@property (weak, nonatomic) IBOutlet UILabel *cashLabel1;
@property (weak, nonatomic) IBOutlet UILabel *couponLabel1;
@property (weak, nonatomic) IBOutlet UILabel *payTypeLabel;//微信支付
@property (weak, nonatomic) IBOutlet UILabel *payTypeLabel1;
@property (weak, nonatomic) IBOutlet UILabel *payUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *payPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation GLD_BusnessOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.commentBut.hidden = YES;
    self.tipLabel.hidden = YES;
}

- (void)setOrderModel:(GLD_OrderModel *)orderModel{
    _orderModel = orderModel;
    self.orderCodeLabel.text = orderModel.orderNumber;
    self.nameLabel.text = orderModel.shopName;
    self.cashLabel.text = [NSString stringWithFormat:@"%.2lf",orderModel.prize];
    //    [self.iconImageV yy_setImageWithURL:[NSURL URLWithString:orderModel.shopPic] placeholder:nil];
    self.couponLabel.text = [NSString stringWithFormat:@"%.2lf",orderModel.discount];
    self.payTypeLabel.text = [NSString stringWithFormat:@"%.2lf",orderModel.wxPay];
    self.dateLabel.text = orderModel.createTime;
    self.payUserLabel.text = orderModel.code;
    self.payPhoneLabel.text = orderModel.phone;
    self.addressLabel.text = orderModel.address;
}

@end
