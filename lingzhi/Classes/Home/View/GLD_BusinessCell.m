//
//  GLD_BusinessCell.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/11/29.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_BusinessCell.h"
#import "GLD_BusnessModel.h"

NSString *const GLD_BusinessCellIdentifier = @"GLD_BusinessCellIdentifier";
@interface GLD_BusinessCell ()

@property(nonatomic, strong)UIImageView *iconImgV;//图片
@property (nonatomic, strong)UILabel *titleLabel;//标题
@property (nonatomic, strong)UILabel *typeLabel;//l类型
@property (nonatomic, strong)UILabel *rankLabel;//等级
@property (nonatomic, strong)UILabel *distanceLabel;//距离
@property (nonatomic, strong)UILabel *detailLabel;//描述
@property (nonatomic, strong)UIButton *locationBut;//位置

@end

@implementation GLD_BusinessCell


- (void)setModel:(GLD_BusnessModel *)model{
    _model = model;
    if([model.logo containsString:@","]){
        NSArray *arr = [model.logo componentsSeparatedByString:@","];
        [self.iconImgV yy_setImageWithURL:[NSURL URLWithString:arr.firstObject] placeholder:nil];
    }else{
        
        [self.iconImgV yy_setImageWithURL:[NSURL URLWithString:model.logo] placeholder:nil];
    }
    self.titleLabel.text = model.name;
    [self.locationBut setTitle:model.address forState:UIControlStateNormal];
    self.typeLabel.text = model.category;
    self.detailLabel.text = GetString(model.desc);
    self.distanceLabel.text = [NSString stringWithFormat:@" 距离%@KM ",IsExist_String(model.distance) ? model.distance : @"12.7"];
    self.rankLabel.text = [NSString stringWithFormat:@"%@星",model.evaluateScore?model.evaluateScore:@"5"];
}
- (void)setupUI{
    
    self.iconImgV = ({
        UIImageView * iconImageView = [UIImageView new];
        iconImageView.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTline2Gray];
        iconImageView;
    });
    self.titleLabel = ({
        UILabel * label = [UILabel new];
        label.text = @"婚恋公司的人";
        label.font = WTFont(15);
        label.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK];
        label;
    });
    self.typeLabel = ({
        UILabel * label = [UILabel new];
        label.font = WTFont(12);
        label.text = @" 婚恋  ";
        
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.borderColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTline2Gray].CGColor;
        label.layer.cornerRadius = 2;
        label.layer.masksToBounds = YES;
        label.layer.borderWidth = 1;
        label.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTline2Gray];
        label;
    });
    self.rankLabel = ({
        UILabel * label = [UILabel new];
        label.font = WTFont(15);
        label.text = @"5星";
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = 5;
        label.layer.masksToBounds = YES;
        label.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE];
        label.textColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKwirte];
        label;
    });
    self.distanceLabel = ({
        UILabel * label = [UILabel new];
        label.font = WTFont(12);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @" 距离0.27km ";
        label.layer.cornerRadius = 2;
        label.layer.masksToBounds = YES;
        label.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTlineGray];
        label.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK];
        label;
    });
    self.detailLabel = ({
        UILabel * label = [UILabel new];
        label.numberOfLines = 2;
        label.font = WTFont(12);
        label.text = @"婚恋公司的人";
        label.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTline2Gray];
        label;
    });
    self.locationBut = ({
        UIButton * button = [UIButton new];
        [button setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
        button.userInteractionEnabled = NO;
        [button setImage:WTImage(@"定位") forState:UIControlStateNormal];
        button.titleLabel.font = WTFont(12);
        [button setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTline2Gray] forState:UIControlStateNormal];
        button;
    });
    [self.contentView addSubview:self.iconImgV];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.rankLabel];
    [self.contentView addSubview:self.distanceLabel];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.locationBut];
    
    
}
- (void)layout{
    [self.iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(W(15));
        make.width.height.equalTo(WIDTH(80));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImgV);
        make.left.equalTo(self.iconImgV.mas_right).offset(W(10));
        make.width.equalTo(WIDTH(120));
    }];
    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(W(-15));
        make.centerY.equalTo(self.titleLabel);
        make.width.equalTo(WIDTH(35));
        make.height.equalTo(WIDTH(25));
    }];
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.rankLabel.mas_left).offset(W(-5));
    }];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(W(5));
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeLabel);
        make.left.equalTo(self.typeLabel.mas_right).offset(W(5));
        make.right.equalTo(WIDTH(190));
    }];
    [self.locationBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.detailLabel.mas_bottom).offset(W(5));
        
    }];
}


@end
