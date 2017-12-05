//
//  GLD_DetaileCell.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/4.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_DetaileCell.h"

NSString *const GLD_DetaileCellIdentifier = @"GLD_DetaileCellIdentifier";
@interface GLD_DetaileCell ()
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *detailLabel;
@property (nonatomic, strong)UIView *lineView;
@end
@implementation GLD_DetaileCell

- (void)setupUI{
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.lineView];
}

- (void)layout{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(W(15));
        make.right.equalTo(self.contentView).offset(W(-15));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(W(15));
        make.right.equalTo(self.contentView).offset(W(-15));
        make.bottom.equalTo(self.titleLabel);
        make.height.equalTo(HEIGHT(1));
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.left.right.equalTo(self.lineView);
//        make.height.equalTo(WIDTH(25));
    }];
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = WTFont(15);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK];
    }
    return _titleLabel;
}
- (UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.font = WTFont(14);
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTline2Gray];
    }
    return _titleLabel;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [YXUniversal colorWithHexString:@"#EBEBEB"];
    }
    return _lineView;
}
@end
