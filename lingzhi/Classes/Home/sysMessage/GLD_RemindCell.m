//
//  GLD_RemindCell.m
//  yxvzb
//
//  Created by yiyangkeji on 17/2/8.
//  Copyright © 2017年 sendiyang. All rights reserved.
//

#import "GLD_RemindCell.h"
#import "GLD_RemindModel.h"

@interface GLD_RemindCell ()
@property (nonatomic, weak)UIImageView *iconImgV;
@property(nonatomic,weak) UILabel *label_tip;

@property(nonatomic,weak) UIView *lineView;
@property(nonatomic,weak) UILabel *label_title;
@property(nonatomic,weak) UILabel *label_subTitle;
@property(nonatomic,weak) UILabel *label_time;
@end
@implementation GLD_RemindCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupUi];
        [self layoutView];
        
        
    }
    return self;
}

- (void)setModel:(GLD_RemindModel *)model{
    _model = model;
    self.accImageV.hidden = NO;
    NSString *picStr = @"管理员消息";
    switch (model.type) {
        case 1:{
            picStr = @"热点阅读";
        }break;
        case 2:{
            picStr = @"身份认证";
        }break;
        case 3:{
            picStr = @"热门帖子";
        }break;
    }
   
    
    
    self.iconImgV.image = [UIImage imageNamed:picStr];
    self.label_tip.text = model.title;
    self.label_title.text = model.summary;
    self.label_subTitle.text = model.footMsg;
//    self.label_time.text = [YXUniversal intervalToDate:[model.historyReceiveTime longLongValue] withFormat:@"MM-dd HH:mm"];
    self.label_time.text = model.time;
    
    
}

- (void)setupUi{
    
    UIImageView *iconImgV = [[UIImageView alloc]init];
    self.iconImgV = iconImgV;
    
    UILabel *tip = [UILabel creatLableWithText:@"正在缓存" andFont:WTFont(15) textAlignment:NSTextAlignmentLeft textColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE]];
    self.label_tip = tip;
    
    UILabel *title = [UILabel creatLableWithText:@"远了" andFont:WTFont(15) textAlignment:NSTextAlignmentLeft textColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKgray3]];
    title.numberOfLines = 0;
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_tableFooter];
    
    UIImageView *accImgV = [[UIImageView alloc]init];
    accImgV.image = [UIImage imageNamed:@"Path 168 Copy 2"];
    self.accImageV = accImgV;
    
    UILabel *time = [UILabel creatLableWithText:@"10:10" andFont:WTFont(10) textAlignment:NSTextAlignmentLeft textColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTnewGray]];
    UILabel *subTitle = [UILabel creatLableWithText:@"医生汇" andFont:WTFont(10) textAlignment:NSTextAlignmentLeft textColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTnewGray]];
    
    [self.contentView addSubview:iconImgV];
    
    [self.contentView addSubview:tip];
    [self.contentView addSubview:title];
    [self.contentView addSubview:accImgV];
    [self.contentView addSubview:lineView];
    [self.contentView addSubview:time];
    [self.contentView addSubview:subTitle];
    
    
    
    self.label_title = title;
    
    self.lineView = lineView;
    self.label_time = time;
    self.label_subTitle = subTitle;
    
}

- (void)layoutView{
    
    [self.iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(WIDTH(15));
        make.width.equalTo(WIDTH(38));
        make.height.equalTo(HEIGHT(38));
    }];
    
    [self.label_tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImgV);
        make.left.equalTo(self.iconImgV.mas_right).offset(W(15));
        make.right.equalTo(self.contentView).offset(-40*DEVICEHEIGHT_SCALE);
        
    }];
    [self.label_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.label_tip);
        make.top.equalTo(self.label_tip.mas_bottom).offset(10);
        make.right.equalTo(self.contentView).offset(W(-30));
//        make.height.equalTo(HEIGHT(40));
        
    }];
    [self.accImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15);
        make.width.equalTo(WIDTH(7));
        make.height.equalTo(HEIGHT(13));
    }];
    
    [self.label_subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.lineView.mas_top).offset(H(-5));
        make.left.equalTo(self.label_title);
    }];
    [self.label_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.label_tip);
        make.right.equalTo(self.contentView).offset(W(-25));
    }];
    
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self.contentView);
        make.height.equalTo(HEIGHT(0.5));
    }];
    
}

@end
