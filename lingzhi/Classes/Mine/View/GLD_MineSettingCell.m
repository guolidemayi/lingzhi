//
//  GLD_MineSettingCell.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/5.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_MineSettingCell.h"
#import "GLD_ButtonLikeView.h"

NSString *const GLD_MineSettingCellIdentifier = @"GLD_MineSettingCellIdentifier";
@interface GLD_MineSettingCell ()

@property (nonatomic, strong)GLD_ButtonLikeView *titleView;
@property (nonatomic, strong)UIImageView *iconImgV;
@property (nonatomic, strong)UILabel *titleLabel;
@end
@implementation GLD_MineSettingCell


- (void)setDict:(NSDictionary *)dict{
    _dict = dict;
    
    self.titleView.title = dict[@"title"];
    self.titleView.imgStr = dict[@"title"];
    self.titleLabel.text = dict[@"detailTitle"];
}
- (void)setupUI {
    [self.contentView addSubview:self.titleView];
    [self.contentView addSubview:self.iconImgV];
    [self.contentView addSubview:self.titleLabel];
}

- (void)layout {

    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self.contentView);
        make.width.equalTo(WIDTH(180));
        make.height.equalTo(WIDTH(25));
    }];
    [self.iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(W(-15));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.iconImgV.mas_left);
        make.centerY.equalTo(self.contentView);
    }];
}


- (GLD_ButtonLikeView *)titleView{
    if (!_titleView) {
        _titleView = [[GLD_ButtonLikeView alloc]initWithTitleColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK] Font:15];
    }
    return _titleView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = WTFont(12);
        _titleLabel.textAlignment = NSTextAlignmentRight;
        _titleLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTnewGray];
    }
    return _titleLabel;
}
- (UIImageView *)iconImgV{
    if (!_iconImgV) {
        _iconImgV = [UIImageView new];
        _iconImgV.image = WTImage(@"更多");
    }
    return _iconImgV;
}
@end
