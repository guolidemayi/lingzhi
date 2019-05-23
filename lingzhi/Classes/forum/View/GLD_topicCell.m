//
//  GLD_topicCell.m
//  yxvzb
//
//  Created by yiyangkeji on 2017/4/27.
//  Copyright © 2017年 sendiyang. All rights reserved.
//

#import "GLD_topicCell.h"
#import "YXButton.h"

@interface GLD_topicCell ()

@property (nonatomic, weak)YXButton *but;
@property (nonatomic, weak)UIImageView *deleteImgV;
@property(nonatomic, weak)UILabel *label;

@end

@implementation GLD_topicCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}


- (void)butClick:(UIButton *)senser{
    if ([self.delegate respondsToSelector:@selector(deleteOraddTopicCallBack: andCell:isDelete:)]) {
        [self.delegate deleteOraddTopicCallBack:self.label.text andCell:self isDelete:NO];
    }
}
- (void)deleteClick{
    if ([self.delegate respondsToSelector:@selector(deleteOraddTopicCallBack: andCell:isDelete:)]) {
        [self.delegate deleteOraddTopicCallBack:self.label.text andCell:self isDelete:YES];
    }
}

- (void)setTopicName:(NSString *)topicName{
    _topicName = topicName;
    self.label.text = topicName;
//    [self.but setTitle:topicName forState:UIControlStateNormal];
    if ([topicName isEqualToString:@"┼"]) {
        self.deleteImgV.hidden = YES;
    }else{
    self.deleteImgV.hidden = NO;
    }
}

- (void)setupUI{
    YXButton *but = [[YXButton alloc]init];
    but.label.font = WTFont(12);
    [but setBackgroundImage:WTImage(@"语音回复Rectangle 29") forState:UIControlStateNormal];
//    [but setTitle:@"+" forState:UIControlStateNormal];
    [but addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:but];
    self.but = but;
    
    [but mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.width.equalTo(WIDTH(75));
        make.height.equalTo(HEIGHT(26));
    }];
    UILabel *label = [UILabel creatLableWithText:@"" andFont:WTFont(12) textAlignment:NSTextAlignmentCenter textColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE]];
    self.label = label;
    
    [but addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(but);
    }];
    UIImageView *imgV = [[UIImageView alloc]initWithImage:WTImage(@"删除图片")];
    imgV.hidden = YES;
    self.deleteImgV = imgV;
    imgV.userInteractionEnabled = YES;
    [imgV addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteClick)]];
    [self.contentView addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(but.mas_right).offset(W(-5));
        make.centerY.equalTo(but.mas_top);
        make.height.width.equalTo(WIDTH(17));
    }];
    
}
@end
