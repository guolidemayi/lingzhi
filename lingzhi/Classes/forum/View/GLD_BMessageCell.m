//
//  GLD_BMessageCell.m
//  yxvzb
//
//  Created by yiyangkeji on 2017/4/24.
//  Copyright © 2017年 sendiyang. All rights reserved.
//

#import "GLD_BMessageCell.h"
#import "GLD_ForumModel.h"
NSString *const GLD_BMessageCellIdentifi = @"GLD_BMessageCellIdentifi";

@interface GLD_BMessageCell ()
{
    UIImageView *_iconImageV;
    UILabel *_nameLabel;
    UILabel *_hospitalLabel;
    UILabel *_dutyLabel;
    UILabel *_titleLabel;
    UIImageView *_titleImgV;
}

@end

@implementation GLD_BMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUpUI];
        [self layout];
    }
    return self;
}

- (void)setUpUI{
    _iconImageV = [[UIImageView alloc]init];
    _iconImageV.layer.cornerRadius = W(17);
    _iconImageV.layer.masksToBounds = YES;
    _iconImageV.userInteractionEnabled = YES;
    [self.contentView addSubview:_iconImageV];
    
    _nameLabel = [UILabel creatLableWithText:@"" andFont:WTFont(14) textAlignment:NSTextAlignmentLeft textColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE]];
    [self.contentView addSubview:_nameLabel];
    
    _hospitalLabel = [UILabel creatLableWithText:@"" andFont:WTFont(10) textAlignment:NSTextAlignmentLeft textColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTline2Gray]];
    [self.contentView addSubview:_hospitalLabel];
    
    _dutyLabel = [UILabel creatLableWithText:@"" andFont:WTFont(10) textAlignment:NSTextAlignmentLeft textColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTline2Gray]];
    [self.contentView addSubview:_dutyLabel];
    
    _titleLabel = [UILabel creatLableWithText:@"" andFont:WTFont(14) textAlignment:NSTextAlignmentLeft textColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKblackNew]];
    _titleLabel.numberOfLines = 2;
    [self.contentView addSubview:_titleLabel];
    
    _titleImgV = [[UIImageView alloc]init];
    _titleImgV.contentMode = UIViewContentModeScaleAspectFill;
    _titleImgV.layer.masksToBounds = YES;
    [self.contentView addSubview:_titleImgV];
}

- (void)layout
{
    [_iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(W(15));
        make.width.height.equalTo(WIDTH(34));
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageV.mas_right).offset(W(10));
        make.top.equalTo(_iconImageV);
    }];
    [_dutyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_nameLabel);
        make.left.equalTo(_nameLabel.mas_right).offset(W(10));
    }];
    [_hospitalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel);
        make.bottom.equalTo(_iconImageV);
    }];
    [_titleImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.contentView).offset(W(-15));
        make.width.equalTo(WIDTH(128));
        make.height.equalTo(WIDTH(72));
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageV);
        make.top.equalTo(_iconImageV.mas_bottom).offset(W(15));
        make.right.equalTo(_titleImgV.mas_left).offset(W(-10));
    }];
}

@end
