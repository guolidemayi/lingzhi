//
//  GLD_MineWalletCell.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/5.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_MineWalletCell.h"

NSString *const GLD_MineWalletCellIdentifier = @"GLD_MineWalletCellIdentifier";
@interface GLD_MineWalletCell ()

@property (nonatomic, strong)UIImageView *iconImgV;
@property (nonatomic, strong)UILabel *titleLabel;//标题
@property (nonatomic, strong)UILabel *tipLabel;//副标题
@property (nonatomic, strong)UILabel *cashLabel;//现金
@property (nonatomic, strong)UILabel *voucherLabel;//券
@property (nonatomic, strong)UILabel *serviceLabel;//服务费
@property (nonatomic, strong)UIView *bgView;//
@property (nonatomic, strong)UIView *lineView;//分割线
@end

@implementation GLD_MineWalletCell

- (void)setHeight:(CGFloat)height{
    _height =height;
    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
    }];
    if (height > 1) {
        [self adjusCashLabel:[NSString stringWithFormat:@"￥%.2f \n 现金", [AppDelegate shareDelegate].userModel.cash] andLabel:self.cashLabel];
        [self adjusCashLabel:[NSString stringWithFormat:@"￥%.2f \n 服务费",[AppDelegate shareDelegate].userModel.cash1] andLabel:self.serviceLabel];
        [self adjusCashLabel:[NSString stringWithFormat:@"%.2f \n 代金券",[AppDelegate shareDelegate].userModel.cash2] andLabel:self.voucherLabel];
       
    }else{
        
    }
}
- (void)adjusCashLabel:(NSString *)title andLabel:(UILabel *)label{
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:title];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:8];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [title length])];
    [label setAttributedText:attributedString1];
    label.textAlignment = NSTextAlignmentCenter;
}
- (void)setupUI {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.tipLabel];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.iconImgV];
    [self.bgView addSubview:self.cashLabel];
    [self.bgView addSubview:self.serviceLabel];
    [self.bgView addSubview:self.voucherLabel];
    
}

- (void)layout {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(W(15));
        
    }];
    [self.iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.contentView).offset(W(-15));
    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.iconImgV.mas_left);
        make.centerY.equalTo(self.titleLabel);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(0.5));
        make.right.left.equalTo(self.contentView);
        make.bottom.equalTo(self.titleLabel).offset(W(10));
    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(0.0001));
        make.bottom.right.left.equalTo(self.contentView);
    }];
    [self.cashLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.bgView);
        make.width.equalTo(@(DEVICE_WIDTH / 3));
        make.centerY.equalTo(self.bgView);
        make.left.equalTo(self.bgView);
    }];
    [self.serviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.bgView);
        make.width.equalTo(@(DEVICE_WIDTH / 3));
        make.centerY.equalTo(self.bgView);
        make.left.equalTo(self.cashLabel.mas_right);
    }];
    [self.voucherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.bgView);
        make.width.equalTo(@(DEVICE_WIDTH / 3));
        make.centerY.equalTo(self.bgView);
        make.left.equalTo(self.serviceLabel.mas_right);
    }];
    
}


- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = WTFont(15);
        _titleLabel.text = @"我的钱包";
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK];
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
- (UIImageView *)iconImgV{
    if (!_iconImgV) {
        _iconImgV = [UIImageView new];
        _iconImgV.image = WTImage(@"更多");
    }
    return _iconImgV;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];

    }
    return _bgView;
}


- (UILabel *)cashLabel{
    if (!_cashLabel) {
        _cashLabel = [UILabel new];
        _cashLabel.font = WTFont(12);
        _cashLabel.numberOfLines = 0;
//        _cashLabel.textAlignment = NSTextAlignmentCenter;
        _cashLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTnewGray];
    }
    return _cashLabel;
}
- (UILabel *)voucherLabel{
    if (!_voucherLabel) {
        _voucherLabel = [UILabel new];
        _voucherLabel.font = WTFont(12);
        _voucherLabel.numberOfLines = 0;
//        _voucherLabel.textAlignment = NSTextAlignmentCenter;
        _voucherLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTnewGray];
    }
    return _voucherLabel;
}

- (UILabel *)serviceLabel{
    if (!_serviceLabel) {
        _serviceLabel = [UILabel new];
        _serviceLabel.font = WTFont(12);
        _serviceLabel.numberOfLines = 0;
        //        _KLabel.textAlignment = NSTextAlignmentCenter;
        _serviceLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTnewGray];
    }
    return _serviceLabel;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [YXUniversal colorWithHexString:@"#EBEBEB"];
    }
    return _lineView;
}
@end
