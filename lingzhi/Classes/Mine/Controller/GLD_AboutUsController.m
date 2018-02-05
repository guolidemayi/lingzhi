//
//  GLD_AboutUsController.m
//  lingzhi
//
//  Created by yiyangkeji on 2018/1/5.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_AboutUsController.h"

@interface GLD_AboutUsController ()

@property (nonatomic, strong)UIImageView *iconImageV;
@property (nonatomic, strong)UITextView *textView;

@end

@implementation GLD_AboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI{
    self.iconImageV = [[UIImageView alloc]initWithImage:WTImage(@"WechatIMG43")];
    [self.view addSubview:self.iconImageV];
    [self.iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(W(30));
        make.width.height.equalTo(WIDTH(100));
    }];
    self.textView = [[UITextView alloc]init];
    self.textView.font = WTFont(14);
    self.textView.userInteractionEnabled = NO;
    self.textView.text = @"惠会联盟会员共享服务平台是由衡水紫君来源商贸有限公司自主研发的一款基于地理位置的O2O社会服务平台，衡水紫君来源商贸有限公司核心聚焦“互联网+新零售”，是一家以底层信息互联技术为核心，通过云数据计算应用，为各行传统行业提供“互联网+”服务。\n惠会联盟管理系统依托互联网+新零售的时代背景，建立联盟会员与商家、商家与商家之间互惠、互利、共享、共赢的生态系统，让会员轻松获得各联盟商家的特别让利，同时还能获得额外的现金补贴；使联盟会员更有意愿在联盟商家重复、愉快消费，使联盟商家获得稳定、并持续增加的客流，也让自己的顾客有机会成为联盟会员而享受到“互联网+”带来的超值红利，同时，联盟商家也可获得”互联网+”带来的跨界丰硕红利。\n惠会联盟会员可以通过系统内圈圈论坛发表分享自己的消费经验，为商家带来分享客源，同时有利于商家改变经营策略，服务模式，商家也可以通过圈圈论坛随时发布优惠政策，来吸引更多客流。\n本软件所有权最终解释权由衡水紫君来源商贸有限公司所有";
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.iconImageV.mas_bottom).offset(W(20));
        make.width.equalTo(WIDTH(340));
         make.height.equalTo(WIDTH(400));
    }];
}


@end
