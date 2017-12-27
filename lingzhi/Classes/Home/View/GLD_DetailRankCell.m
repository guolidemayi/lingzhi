//
//  GLD_DetailRankCell.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/4.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_DetailRankCell.h"

NSString *const GLD_DetailRankCellIdentifier = @"GLD_DetailRankCellIdentifier";
@interface GLD_DetailRankCell ()
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *detailLabel;

@end
@implementation GLD_DetailRankCell

- (void)setupUI{
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.detailLabel];
    
}
- (void)setStarCont:(NSInteger)starCont{
    _starCont = starCont;
    self.detailLabel.text = [NSString stringWithFormat:@"%zd 分",starCont];
    for (int i = 0; i < starCont; i++) {
        UIImageView *imgV = [[UIImageView alloc]initWithImage:WTImage(@"starEvaluateYes")];
        [self.contentView addSubview:imgV];
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.width.height.equalTo(WIDTH(10));
            make.right.equalTo(self.detailLabel.mas_left).offset(-W(10 * i));
        }];
    }
}
- (void)layout{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(W(15));
        make.centerY.equalTo(self.contentView);
//        make.right.equalTo(self.contentView).offset(W(-15));
    }];
   
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-5);
        make.width.equalTo(WIDTH(50));
    }];
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = WTFont(15);
        _titleLabel.text = @"评分";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE];
    }
    return _titleLabel;
}
- (UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.font = WTFont(15);
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTyellow];
    }
    return _detailLabel;
}
@end
