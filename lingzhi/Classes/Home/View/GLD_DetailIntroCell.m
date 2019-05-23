//
//  GLD_DetailIntroCell.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/4.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_DetailIntroCell.h"
#import "GLD_ButtonLikeView.h"
#import "GLD_BusnessModel.h"

NSString *const GLD_DetailIntroCellIdentifier = @"GLD_DetailIntroCellIdentifier";
@interface GLD_DetailIntroCell ()
@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, strong)GLD_ButtonLikeView *addressView;
@property (nonatomic, strong)GLD_ButtonLikeView *phoneView;
@end

@implementation GLD_DetailIntroCell


- (void)setBusnessModel:(GLD_BusnessModel *)busnessModel{
    _busnessModel = busnessModel;
    self.titleLabel.text = busnessModel.name;
    [self.addressView setTitle:busnessModel.address];
    [self.phoneView setTitle:busnessModel.cellphone];
}
- (void)setupUI{
    [self.contentView addSubview:self.addressView];
    [self.contentView addSubview:self.phoneView];
    [self.contentView addSubview:self.titleLabel];
    
}

- (void)layout{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(W(15));
        make.right.equalTo(self.contentView).offset(W(-15));
    }];
    [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(WIDTH(25));
    }];
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressView.mas_bottom).offset(5);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(WIDTH(25));
    }];
}

- (GLD_ButtonLikeView *)addressView{
    if (!_addressView) {
        _addressView = [[GLD_ButtonLikeView alloc]initWithTitleColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTnewGray] Font:12];
        _addressView.imgStr = @"地址";
    }
    return _addressView;
}
- (GLD_ButtonLikeView *)phoneView{
    if (!_phoneView) {
        _phoneView = [[GLD_ButtonLikeView alloc]initWithTitleColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTnewGray] Font:12];
        _phoneView.imgStr = @"电话";
    }
    return _phoneView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = WTFont(15);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK];
    }
    return _titleLabel;
}
@end
