//
//  GLD_IndustryCollecCell.m
//  lingzhi
//
//  Created by Jin on 2017/12/2.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_IndustryCollecCell.h"
#import "GLD_IndustryModel.h"

NSString *const GLD_IndustryCollecCellIdentifier = @"GLD_IndustryCollecCellIdentifier";
@interface GLD_IndustryCollecCell ()

@property (nonatomic, strong)UIImageView *iconImgV;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation GLD_IndustryCollecCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self layout];
    }
    return self;
}

- (void)setModel:(GLD_IndustryModel *)model{
    _model = model;
    [self.iconImgV yy_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholder:nil];
    self.titleLabel.text = model.title;
}
- (void)setupUI{
    [self.contentView addSubview:self.iconImgV];
    [self.contentView addSubview:self.titleLabel];
}
- (void)layout{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(W(-15));
    }];
    [self.iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.titleLabel).offset(W(-15));
    }];
}
- (UIImageView *)iconImgV{
    if (!_iconImgV) {
        _iconImgV = [UIImageView new];
        
    }
    return _iconImgV;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = WTFont(12);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK];
    }
    return _titleLabel;
}
@end
