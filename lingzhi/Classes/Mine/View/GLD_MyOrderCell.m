//
//  GLD_MyOrderCell.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/28.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_MyOrderCell.h"

NSString *const GLD_MyOrderCellIdentifier = @"GLD_MyOrderCellIdentifier";
@interface GLD_MyOrderCell ()

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
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (nonatomic, assign)callBackType type;
@end
@implementation GLD_MyOrderCell


+ (GLD_MyOrderCell *)cellWithReuseIdentifier:(NSString *)reuseIdentifier{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:reuseIdentifier owner:nil options:nil];
    GLD_MyOrderCell *cell = (GLD_MyOrderCell*)[topLevelObjects firstObject];
    cell.commentBut.hidden = YES;
    cell.tipLabel.hidden = YES;
    return cell;
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
    self.addressLabel.text = orderModel.address;
}
- (IBAction)commentClick:(UIButton *)sender {
    if ([self.orderDelegate respondsToSelector:@selector(commentCallBack: andBusnessId:)]) {
        [self.orderDelegate commentCallBack:callBackTypeComment andBusnessId:@""];
    }
}

@end
