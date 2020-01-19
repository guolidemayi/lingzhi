//
//  GLD_TMessageCell.m
//  yxvzb
//
//  Created by yiyangkeji on 2017/4/21.
//  Copyright © 2017年 sendiyang. All rights reserved.
//

#import "GLD_TMessageCell.h"
#import "GLD_ForumModel.h"
#import "UIView+gldController.h"
#import "GLD_BusinessDetailController.h"

NSString  *const GLD_TMessageCellIdentifi = @"GLD_TMessageCellIdentifi";
@interface GLD_TMessageCell ()
{
    UIImageView *_iconImageV;
    UILabel *_nameLabel;
    UILabel *_dutyLabel; //职称
    UILabel *_timeLabel;
    UILabel *_readLabel;
    UILabel *_titleLabel;
    UILabel *_contentLabel;
    UIImageView *_titleImgV;
}

@end

@implementation GLD_TMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUpUI];
        [self layout];
        
        [_iconImageV addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iconImageClick)]];
    }
    return self;
}

- (void)iconImageClick{
    if (self.BLdetailModel.isShop.boolValue) {
         GLD_BusinessDetailController *detaileVc = [GLD_BusinessDetailController new];
        detaileVc.userId = self.BLdetailModel.userId;
        [self.navigationController pushViewController:detaileVc animated:YES];

    }
}
- (void)setBLdetailModel:(GLD_ForumDetailModel *)BLdetailModel{
    _BLdetailModel = BLdetailModel;
    
    [_iconImageV yy_setImageWithURL:[NSURL URLWithString:BLdetailModel.userPhoto] placeholder:[UIImage imageNamed:@"默认头像"]];
    _dutyLabel.text = BLdetailModel.dutie;
    _timeLabel.text = BLdetailModel.companyName;
    
    if (!IsExist_String(BLdetailModel.pic)) {
       
        [_titleImgV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(WIDTH(0.1));
        }];
        
        [self layoutIfNeeded];
    }else{
        NSArray *arr = [BLdetailModel.pic componentsSeparatedByString:@","];
        if(IsExist_Array(arr)){
        [_titleImgV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(WIDTH(65));
        }];
        [_titleImgV yy_setImageWithURL:[NSURL URLWithString:arr.firstObject] placeholder:nil];
        }
    }
    _nameLabel.text = !IsExist_String(BLdetailModel.userName) ? BLdetailModel.nickName : BLdetailModel.userName;
    _titleLabel.text = BLdetailModel.title;
    _contentLabel.text = BLdetailModel.summary;
    
//    _readLabel.text = [self tipStr:BLdetailModel];
}

- (NSString *)tipStr:(GLD_ForumDetailModel *)careModel{
    
    if(careModel.commentCount >= 20){
        return [NSString stringWithFormat:@"%zd 位同行讨论",careModel.commentCount];
    }
    if(careModel.collectionCount >= 10){
        return [NSString stringWithFormat:@"%zd 位同行收藏",careModel.collectionCount];
    }
    return [NSString stringWithFormat:@"%zd 位同行阅读",careModel.readCount];
}

- (void)setUpUI{
    _iconImageV = [[UIImageView alloc] init];
    _iconImageV.layer.cornerRadius = W(17);
    _iconImageV.layer.masksToBounds = YES;
    _iconImageV.userInteractionEnabled = YES;
    [self.contentView addSubview:_iconImageV];
    
    _nameLabel = [UILabel creatLableWithText:@"" andFont:WTFont(14) textAlignment:NSTextAlignmentLeft textColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE]];
    
    [self.contentView addSubview:_nameLabel];
    
    _dutyLabel = [UILabel creatLableWithText:@"" andFont:WTFont(10) textAlignment:NSTextAlignmentLeft textColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTline2Gray]];
    
    [self.contentView addSubview:_dutyLabel];
    _timeLabel = [UILabel creatLableWithText:@"" andFont:WTFont(10) textAlignment:NSTextAlignmentLeft textColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTline2Gray]];
    [self.contentView addSubview:_timeLabel];
    
    _readLabel = [UILabel creatLableWithText:@"" andFont:WTFont(10) textAlignment:NSTextAlignmentLeft textColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTline2Gray]];
    [self.contentView addSubview:_readLabel];
    
    _titleLabel = [UILabel creatLableWithText:@"" andFont:WTFont(14) textAlignment:NSTextAlignmentLeft textColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKblackNew]];
    [self.contentView addSubview:_titleLabel];
    
    _contentLabel = [UILabel creatLableWithText:@"" andFont:WTFont(12) textAlignment:NSTextAlignmentLeft textColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTline2Gray]];
    _contentLabel.numberOfLines = 2;
    [self.contentView addSubview:_contentLabel];
    
    _titleImgV = [[UIImageView alloc] init];
    _titleImgV.contentMode = UIViewContentModeScaleAspectFill;
    _titleImgV.layer.masksToBounds = YES;
    [self.contentView addSubview:_titleImgV];
}

- (void)layout{
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
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel);
        make.bottom.equalTo(_iconImageV);
    }];
    [_readLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(W(-15));
        make.centerY.equalTo(_timeLabel);
    }];
    [_titleImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.contentView).offset(W(-15));
        make.width.height.equalTo(WIDTH(65));
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageV);
        make.top.equalTo(_iconImageV.mas_bottom).offset(W(15));
        make.right.equalTo(_titleImgV.mas_left).offset(W(-10));
    }];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel);
        make.top.equalTo(_titleLabel.mas_bottom).offset(W(10));
        make.right.equalTo(_titleLabel);
    }];
}

@end
