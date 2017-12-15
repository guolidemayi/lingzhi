//
//  GLD_SearchResultCell.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/7.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_SearchResultCell.h"
#import <AMapSearchKit/AMapSearchKit.h>
NSString *const GLD_SearchResultCellIdentifier = @"GLD_SearchResultCellIdentifier";
@interface GLD_SearchResultCell ()

@property (nonatomic, strong)UIImageView *iconImgV;
@property (nonatomic, strong)UILabel *titleLabel;//标题
@property (nonatomic, strong)UILabel *tipLabel;//副标题
@property (nonatomic, strong)UILabel *cashLabel;//现金
@property (nonatomic, strong)UIImageView *titleImgV;
@end
@implementation GLD_SearchResultCell


- (void)setItem:(AMapPOI *)item{
    _item = item;
    self.titleLabel.text = item.name;
    self.tipLabel.text = item.address;
    self.cashLabel.text = item.tel;
    if (IsExist_Array(item.images)) {
        [self.titleImgV yy_setImageWithURL:[NSURL URLWithString:item.images.firstObject.url] placeholder:nil];
    }
}
- (void)setupUI {
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.tipLabel];
    [self.contentView addSubview:self.cashLabel];
    [self.contentView addSubview:self.titleImgV];
    [self.contentView addSubview:self.iconImgV];
     self.selectionStyle = UITableViewCellSelectionStyleGray;
}

- (void)layout{

    [self.iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.contentView);
        make.left.top.equalTo(self.contentView).offset(15);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImgV);
        make.left.equalTo(self.iconImgV.mas_right);
    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        
    }];
    [self.cashLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipLabel);
        make.top.equalTo(self.tipLabel.mas_bottom).offset(5);
    }];
    [self.titleImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(W(-15));
        make.top.equalTo(self.iconImgV);
        make.height.equalTo(WIDTH(60));
        make.width.equalTo(WIDTH(80));
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
        _iconImgV.image = WTImage(@"marker_defaut");
    }
    return _iconImgV;
}
- (UIImageView *)titleImgV{
    if (!_titleImgV) {
        _titleImgV = [UIImageView new];
        _titleImgV.image = WTImage(@"更多");
    }
    return _titleImgV;
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
@end
