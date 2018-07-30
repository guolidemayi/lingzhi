//
//  GLD_GoodsDetailController.m
//  lingzhi
//
//  Created by yiyangkeji on 2018/7/30.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_GoodsDetailController.h"
#import "GLD_GoodsDetailManager.h"

@interface GLD_GoodsDetailController ()
@property (nonatomic, strong)GLD_GoodsDetailManager *goodsDetailManager;
@property (nonatomic, strong)UITableView *home_table;
@property (nonatomic, strong)UIButton *applyBut;
@end

@implementation GLD_GoodsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setApplyBut];
    self.home_table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.home_table];
    [self.home_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.applyBut.mas_top);
    }];
    self.goodsDetailManager = [[GLD_GoodsDetailManager alloc]initWithTableView:self.home_table];
    self.goodsDetailManager.storeModel = self.storeModel;
    [self.goodsDetailManager fetchMainData];
}

- (void)setApplyBut{
    [self.view addSubview:self.applyBut];
    [self.applyBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self.view);
        make.height.equalTo(@(64));
    }];
}
- (void)applybutClick{
    
}
- (UIButton *)applyBut{
    if (!_applyBut) {
        _applyBut = [[UIButton alloc]init];
        [_applyBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKyellow] forState:UIControlStateNormal];
        [_applyBut setTitle:@"立即购买" forState:UIControlStateNormal];
        _applyBut.titleLabel.font = WTFont(15);
        _applyBut.layer.cornerRadius = 3;
        _applyBut.layer.masksToBounds = YES;
        _applyBut.layer.borderColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKyellow].CGColor;
        _applyBut.layer.borderWidth = 1;
        _applyBut.hidden = YES;
        [_applyBut addTarget:self action:@selector(applybutClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyBut;
}
@end
