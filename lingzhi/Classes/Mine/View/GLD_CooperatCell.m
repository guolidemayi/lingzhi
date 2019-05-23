//
//  GLD_CooperatCell.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/11.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_CooperatCell.h"

NSString *const GLD_CooperatCellIdentifier = @"GLD_CooperatCellIdentifier";
@interface GLD_CooperatCell ()


@property (nonatomic, strong)UILabel *titleLabel;//标题
@property (nonatomic, strong)UILabel *tipLabel;//副标题
@property (nonatomic, strong)UIButton *applyBut;//现金

@end
@implementation GLD_CooperatCell

- (void)setupUI {
    [self.contentView addSubview:self.tipLabel];
[self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.applyBut];
}

- (void)setDict:(NSDictionary *)dict{
    _dict = dict;
    self.titleLabel.text = dict[@"title"];
    self.tipLabel.text = dict[@"tip"];
}
- (void)layout{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(W(15));
        make.width.equalTo(WIDTH(200));
    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(W(5));
        make.width.equalTo(self.titleLabel);
    }];
    [self.applyBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(W(-15));
        make.width.equalTo(WIDTH(100));
        make.height.equalTo(WIDTH(35));
    }];
}
- (void)applybutClick{
    if (self.cooperatBlock) {        
        self.cooperatBlock([self.dict[@"type"] integerValue]);
    }
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
        _tipLabel.textAlignment = NSTextAlignmentLeft;
        _tipLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTnewGray];
    }
    return _tipLabel;
}
- (UIButton *)applyBut{
    if (!_applyBut) {
        _applyBut = [[UIButton alloc]init];
        [_applyBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKyellow] forState:UIControlStateNormal];
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
